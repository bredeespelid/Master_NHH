# Set environment variables and create openai client
import os 
import json 
from openai import AzureOpenAI
from google.colab import userdata # To get the secret keys
from openai.types.chat import ChatCompletionUserMessageParam, ChatCompletionSystemMessageParam

# Deployment name in azure openai studio
gpt_model = "gpt-4o-mini"  # ex. gpt-4o-mini

# Create openai client
client = AzureOpenAI(
    api_key=userdata.get('AZURE_OPENAI_API_KEY'),
    api_version="2023-03-15-preview",
    azure_endpoint=userdata.get('AZURE_OPENAI_ENDPOINT'),
)

# Folder that stores the VTT-files
directory_path = "/content/Debatten_subtitles/"

# List to store analysis results
analysis_results = []


# Loop over the files in the directory
for filename in os.listdir(directory_path):
    if filename.endswith(".vtt"):
        file_path = os.path.join(directory_path, filename)

        # Read the VTT file
        with open(file_path, "r", encoding="UTF-8") as file:
            data = file.read()

        # Process the VTT file
        messages = [
            {
                "role": "system",
                "content": """
                                      You are an expert in language analysis and interaction analysis in discussions, with a focus on identifying all unique speakers in dialogue.
                    Your task is to analyze the entire text provided, which may be in Norwegian or English.
                    }
                """
            },
            {
                "role": "user",
                "content": f"""

        1. Identify and label each unique speaker in the transcript based on their dialogue content, contextual cues, or conversational markers.
        2. Assign a unique identifier to each speaker ("Debater 1", "Debater 2," or "Expert 1" etc.) and determine their gender (M/F) when possible based on their name. Do not include their real name in the output.
        3. Include all participants present in the text and ensure no speaker is omitted. Do not limit the identification to a predefined number of examples.
        4. Analyze variations in language usage, word choice, or conversational patterns in the transcript to differentiate between speakers.
        5. Comprehensive Interaction Analysis: Evaluate and score the interactions between all debaters, not just a sample. This analysis should include every interaction and response in the provided text to ensure an accurate and holistic assessment of how each participant interacts with others.

        Scoring Categories:
                        -Argument Clarity and Relevance:
                              Negative (1-4):
                                "Unclear or illogical arguments. Poor relevance to the topic."
                                Example: "Krisesentrene, politisakene, de bulmer over. Ta realiteten innover deg."
                              Neutral (5):
                                "Moderately clear arguments with basic logical structure. Generally relevant to the topic."
                                Example: "Det Norge jeg kom til har endret seg. I dag er det noen som ikke engang har kommet hit ennå, de har en annen kultur og forventer at Norge skal tilpasse seg."
                              Positive (6-9):
                                "Clear, logically structured arguments. Highly relevant to the topic with strong supporting evidence."
                                Example: "De vestlige verdiene står på spill. Demokrati. Ytringsfrihet. Religionsfrihet. Likestilling, synet på homofile. Dette kolliderer med manges praksis."
                        -Engagement style:
                              Negative (1-4):
                                "Limited or no engagement with opponent's arguments. Weak or irrelevant counterarguments."
                                Example: "Jeg velger å ignorere det du sier. Det må være lov å kose seg."
                              Neutral (5):
                                "Basic engagement with main points. Adequate counterarguments, but lacking depth or consistency."
                                Example: "Jeg mener at for å skape dialogen, kan vi ikke ta utgangspunkt i at all muslimsk ungdom er på én måte. Men se nyansene."
                              Positive (6-9):
                                "Excellent engagement with opponent's arguments. Precise identification of weaknesses. Strong, well-formulated counterarguments."
                                Example: "Vi har studier som viser det Dankel påpeker, men det betyr ikke en sammenheng. Poenget er at vi ikke kan se på totalt inntak, men undergrupper og prosesseringsgrad innad i dem."
                        -Power Use:
                              Negative (1-4):
                                Description: Frequent interruptions or complete disregard for other participants' contributions. Little or no acknowledgment of opposing arguments. The language may be overly assertive or dismissive, even without vocal tone cues.
                                Example from transcript: "Du generaliserer en generasjon. Syv skoler ... Hvor mange elever?"
                              Neutral (5):
                                Description: Moderate power use with occasional dismissal of opposing points, but without excessive dominance. The argumentation shows some balance, and the responses hint at collaboration or acknowledgment.
                                Example from transcript:
                                  Debater 1: "Synet på homofile, dette har vi sett i klasserom og i forskning. Elever med muslimsk bakgrunn kommer dårligst ut ved holdningsundersøkeler."
                                  Debater 2: "Men vi må se det i historisk perspektiv. Det var forbudt i Norge for 50 år siden."
                              Positive (6-9):
                                Description: Respectful and balanced interaction. Opposing points are explicitly addressed and built upon. Collaboration is evident, with a willingness to consider different perspectives in the discussion.
                                Example from transcript:
                                  Debater 1: "Jeg skremmer ikke samfunnet. Samfunnet blir skremt av det de ser. Muslimene tar ikke debattene. Det er manglende likestilling."
                                  Debater 2: "Jeg er glad du tar opp utfordringene, men måten vi gjør det på kan skape mer dialog. Kanskje vi kan sette et felles mål for integrering."

        6. Use an analysis model: Analyze how gender patterns may influence treatment in interactions, while controlling for other variables.
        7. Scoring: All scoring should be in the interval 1-9, 1 is the lowest and 9 is the highest.
        8. Final Scoring: Combine scores across all categories for each participant to assign a final score reflecting their overall performance and engagement style in the full debate.

        Analyze the interactions between all participants and categorize them into gender-based combinations (M to M, F to M, F to F, M to F). Ensure the output is presented in JSON format as follows:
        {{
            "episode_name": "<generated_name>",
            "participants": [
                {{
                    "role": "<role>",
                    "gender": "<M/F>",
                    "background": "(party affiliation, organization, etc.)"
                }}
            ],
            "interaction_analysis": {{
                "M_to_M": {{
                    "Argument Clarity and Relevance": <number>,
                    "Summary Argument Clarity and Relevance": "<summary>",
                    "Engagement Style": <number>,
                    "Summary Engagement Style": "<summary>",
                    "Power Use": <number>,
                    "Summary Power Use": "<summary>",
                    "Total score (average of all)": <number>,
                    "Total summary": "<summary>"
                }},
                "F_to_F": {{
                    "Argument Clarity and Relevance": <number>,
                    "Summary Argument Clarity and Relevance": "<summary>",
                    "Engagement Style": <number>,
                    "Summary Engagement Style": "<summary>",
                    "Power Use": <number>,
                    "Summary Power Use": "<summary>",
                    "Total score (average of all)": <number>,
                    "Total summary": "<summary>"
                }},
                "F_to_M": {{
                    "Argument Clarity and Relevance": <number>,
                    "Summary Argument Clarity and Relevance": "<summary>",
                    "Engagement Style": <number>,
                    "Summary Engagement Style": "<summary>",
                    "Power Use": <number>,
                    "Summary Power Use": "<summary>",
                    "Total score (average of all)": <number>,
                    "Total summary": "<summary>"
                }},
                "M_to_F": {{
                    "Argument Clarity and Relevance": <number>,
                    "Summary Argument Clarity and Relevance": "<summary>",
                    "Engagement Style": <number>,
                    "Summary Engagement Style": "<summary>",
                    "Power Use": <number>,
                    "Summary Power Use": "<summary>",
                    "Total score (average of all)": <number>,
                    "Total summary": "<summary>"
                }}
            }},
            "overall_trends": "<description>",
            "final_score": <number>
        }}

        Analyze the text below and categorize participants as “debater 1,” “debater 2,” “expert 1,” etc., not their real name. Evaluate how they interact with each other in all gender combinations (M to M, F to M, F to F, M to F). Include all participants and do not include the moderator in the analysis. In English only.

        <data>{data}</data>
    """
            }
        ]

        #Request to OpenAI
        completion = client.chat.completions.create(
        model="gpt-4o-mini", 
        messages=messages,
        temperature=0.4,
        response_format={"type": "json_object"},  # Guarantees that the response is in JSON format
)

        #Store the analysis result
        if completion.choices[0].message.content:
            analysis_result = json.loads(completion.choices[0].message.content)
            analysis_result["episode_name"] = filename.replace(".vtt", "")  
            analysis_results.append(analysis_result)

            #Print the file names
            print(f"Finished analyzing: {filename}")

# Print the final stored json results
final_json_result = json.dumps(analysis_results, indent=4)
print(final_json_result)

