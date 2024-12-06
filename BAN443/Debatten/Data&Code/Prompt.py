from openai import OpenAI


path_to_file = "Test.txt"

# Read the data from the file
with open(path_to_file, "r", encoding="UTF-8") as file:
    data = file.read()

messages = [
    {
        "role": "system",
        "content": """
            Du er en ekspert på språkanalyse og moderering i debattformat. Din hovedoppgave er å analysere
            debattdata og score moderatorens behandling av ulike deltakere basert på spesifikke trekk.

            Din tilnærming består av fire trinn:

            1. Merk dataen (Step 1): Hver linje som en ny hendelse i debatten med tidspunkter og talere.
            2. Vurder moderatorbehandling (Step 2): Score hver taler basert på hvordan moderator behandler dem
               (avbrudd, hvor lang tid de får snakke, bruk av assertivt språk osv.). Vær bevisst på hva AI får vite om hver taler i denne vurderingen.
            3. Vurder prediktorer (Step 3): Score hver taler på variabler som kan forutsi hvordan moderator behandler dem
               (avledning, tidshåndtering, saklighet, osv.).
            4. Bruk regresjonsanalyse (Step 4): Test hvorvidt kjønn kan forutsi ulike behandlinger fra moderator,
               mens du kontrollerer for andre prediktorer.

            Resultatene skal være kortfattede og tydelige. Sammenfatte poengsummene for hver deltaker
            i en <score> tag og spesifisere hvilken type behandling de mottok fra moderator.
            Endelig poengsum skal ligge mellom 0 og 10, hvor 0 er negativt, 5 er nøytralt, og 10 er svært positivt.
        """
    },
    {
        "role": "user",
        "content": f"""
            Analyser debattinteraksjonene i teksten under for å score moderatorens behandling av hver taler.
            Ta hensyn til både moderatorens stil og deltakernes adferd.

            <data>{data}</data>

            Analyse:
        """
    },
]

completion = client.chat.completions.create(
    model="gpt-4o-mini",  # Replace with your actual model name
    messages=messages,
    temperature=0.2,
)

assert completion.choices[0].message.content is not None

print(completion.choices[0].message.content)

# Extract the final score from the completion tag
final_score = completion.choices[0].message.content.split("<score>")[1].split("</score>")[0]
print("\n Final score:", final_score)
