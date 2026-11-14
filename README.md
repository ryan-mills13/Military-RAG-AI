# Military Document RAG AI

## Project Overview

Our project focuses on creating a basic Retrieval-Augmented Generation (RAG) model using RStudio. The goal is to help users find information in military documents without having to manually search through the entire document.

The model reads military PDFs, identifies relevant information using TF-IDF and cosine similarity, and uses a local AI model to generate answers based on the retrieved passages. It also provides the document name, page number, and similarity score.

## How Our Model Works

1. **Document Loading:** The program reads PDF files from the `Documents` folder.
2. **Text Chunking:** Each page is divided into smaller sections of approximately 1,000 characters.
3. **TF-IDF:** The model calculates how important words are within each section.
4. **Cosine Similarity:** The model compares the user's question to the document sections and ranks them by similarity.
5. **AI Answer Generation:** The top three matching sections are sent to a local Llama 3.2 model through Ollama to generate an answer.
6. **Sources:** The program displays the original document, page number, similarity score, and retrieved text.

## Requirements

To run the project, users need:

- R and RStudio
- R packages: `pdftools`, `httr`, and `jsonlite`
- Ollama installed and running locally
- The `llama3.2` model downloaded in Ollama
- At least one authorized, unclassified, text-based military PDF

## Setup Instructions


1. Download or clone this GitHub repository.
2. Open the project in RStudio.
3. Create a folder named `Documents` inside the project folder.
4. Add a military PDF to the `Documents` folder. For example, use an authorized copy of *AFCWI 36-3501, Cadet Standards and Duties*.
5. Open the main R script and run the entire file.
   The next step (step 6) is not needed for this check point, however we will get it working for the final project.
6. Make sure Ollama is running and has the Llama 3.2 model installed.
7. Use `ask_rag()` in the RStudio Console to ask questions.

To download the AI model, run this command in your computer's Terminal:


ollama pull llama3.2

Disclaimer: it will run without ollama because we currently still need to figure that part on our computer.

## Example Questions

After running the script, users can ask. we currently have these in the code so the output can be seen:

ask_rag("What are the responsibilities of cadets?")
ask_rag("What are the uniform standards?")


The program generates an answer and displays the supporting document sections with their page numbers and similarity scores.

## Verification Tests

We included two automated tests to check whether the retrieval algorithm works correctly.

**Test 1: Physical Training**

- Question: "cadet physical training"
- Expected result: Retrieve the sample training document.
- Purpose: Verify that the algorithm can find information about cadet physical training.

**Test 2: Aircraft Maintenance**

- Question: "aircraft maintenance safety"
- Expected result: Retrieve the sample safety document.
- Purpose: Verify that the algorithm can find information about aircraft maintenance.

Both tests use sample text created directly in the code, so users do not need separate `training.pdf` or `safety.pdf` files.

To run the tests in RStudio:

```r
run_tests()
```

The script reports whether each test passes. These tests evaluate retrieval, not the accuracy of the AI-generated answers.

## Current Limitations

Our model may retrieve passages that are not directly relevant to the user's question. It also relies on matching words, so questions using different terminology may produce weaker results. The AI-generated answers must still be checked against the original documents.
We also still need to figure out the Ollama portion and make sure it is running smoothly.
## Future Improvements

We plan to improve retrieval accuracy, reduce irrelevant results, and evaluate how well the AI-generated answers match the supporting documents.
