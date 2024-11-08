# Terraform Workshop: Deploying a GCP Cloud Function

## Overview

This repository contains the code and resources for a workshop focused on deploying a Google Cloud Platform (GCP) Cloud Function using Terraform. Participants will learn how to utilize Terraform for infrastructure as code and deploy a serverless function that interacts with BigQuery.

## Prerequisites

Before you begin, make sure you have the following:

-   **Text Editor**: You can use whichever text editor you prefer, but we suggest using Visual Studio Code.

-   **Terraform Installation**:

    -   **Installing Terraform using Homebrew**:

        1. Open your terminal.
        2. If you don’t have Homebrew installed, you can install it by running the following command:
            ```bash
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ```
        3. Once Homebrew is installed, you can install Terraform with:
            ```bash
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
            ```

    -   **Installing Terraform without Homebrew**:
        1. Download the latest Terraform binary from the [Terraform downloads page](https://www.terraform.io/downloads.html).
        2. Unzip the downloaded file and move the `terraform` binary to a directory included in your `PATH`. For example:
            ```bash
            sudo mv terraform /usr/local/bin/
            ```
        3. Verify the installation by running:
            ```bash
            terraform -v
            ```

-   **Access to GCP**: We will be using a service account for deploying the architecture, but access to GCP's console is a nice-to-have.

## Cloning the Repository Locally

To clone this repository to your local machine, follow these steps:

1. **Installing Git**: Ensure that you have Git installed on your computer. To check you have it properly installed, run the following command on the terminal and if it returns successfully you have git installed!

    ```
     git -v
    ```

    Git is installed, you will see the version number displayed. If you encounter an error, please ensure that Git is installed correctly.

2. **Open Your Terminal or Command Prompt**: Use you preferred Terminal application. You can also use VSCode's terminal by holding down `Cmd + Shift + P` and writing `Terminal: Create New Terminal`

3. **Navigate to Your Desired Directory**: Use the `cd` command to change to the directory where you want to clone the repository. For example:
    ```bash
    cd Documents/trainings/
    ```
4. **Clone the Repository:** Use the git clone command followed by the repository URL.

    ```
    git clone [REPO URL]
    ```

    Replace [REPO URL] with the actual URL of the repository.

5. **Change into the Cloned Directory:** After cloning, navigate into the newly created directory with the following command:
    ```bash
    cd terraform-workshop
    ```
6. Verify the Clone: You can verify that the repository has been cloned successfully by listing the files:
   `bash
ls
`
   You should see the contents of the repository listed in your terminal. Now you have a local copy of the repository, and you can start working on it!

## Cloud Function Details

The cloud function in this workshop is built with Node.js and utilizes GCP's BigQuery Node.js Client Library. This function is designed to access a public BigQuery table, parse relevant information for each record, and convert it into a string format. The function is triggered via HTTP requests, making it accessible and easy to integrate with other services.

-   **Node.js**: [Node.js Official Site](#)
-   **BigQuery Node.js Client Library**: [BigQuery Client Library](#)

## Architecture Diagram

![Architecture Diagram](./assets/terraform-flow.png)

## Branches Overview

| Branch Name   | Description                                                               | Terminal Command                    |
| ------------- | ------------------------------------------------------------------------- | ----------------------------------- |
| `main`        | An intro to the workshop. This only contains the README.md and its assets | `git checkout main`                 |
| `source-code` | Includes the source code for the cloud function we will be deploying      | `git checkout source-code`          |
| `workshop-s1` | Contains the code for section 1 of the workshop                           | `git checkout workshop-s1`          |
| `workshop-s2` | Contains the code for section 2 of the workshop                           | `git checkout workshop-s2`          |
| `workshop-s3` | Contains the code for section 3 of the workshop                           | `git checkout workshop-s3`          |
| `workshop-s4` | Includes the final code for the workshop                                  | `git checkout feature/http-trigger` |

# What is Terraform?

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It allows users to define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL). With Terraform, you can manage cloud services, virtual machines, and other infrastructure components efficiently.

[Learn more about Terraform](https://www.terraform.io/)

[Terraform Docs](https://developer.hashicorp.com/terraform?product_intent=terraform)

## Terraform Registry

It is a centralized repository where users can find, share, and use Terraform modules and providers. It allows developers to discover reusable infrastructure code, making it easier to manage and provision resources across various cloud providers and services. The registry includes both official modules provided by HashiCorp and community-contributed modules, promoting collaboration and best practices in infrastructure as code.

[Google Cloud Platform's Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

## Additional Resources

-   [Workshop Presentation Deck](#)
-   [Terraform Installation Guide](#)
-   [Terraform GCP Registry](#)
-   ["Understanding Terraform: A Beginner's Guide" by John Doe](#)
-   ["Understanding Terraform: A Beginner's Guide" by John Doe](#)
-   ["Understanding Terraform: A Beginner's Guide" by John Doe](#)

Feel free to explore the repository, follow the instructions in the README, and reach out with any questions during the workshop!
