GitOps powered by version-controlled Git repositories, offers a practical solution for managing infrastructure and applications. This approach has gained popularity with the rise of platforms like Kubernetes, and has found a new home in Terraform, especially for infrastructure-as-code (IaC). Atlantis and ArgoCD are currently the two of the most popular GitOps tools, this article shows how to integrate them with GitHub Actions (GHA) for effective Terraform workflows.

Introduction to Atlantis

Atlantis is an open-source tool designed to automate Terraform workflows, particularly in a collaborative environment. It integrates seamlessly with version control systems and provides a simple way to manage Terraform state.

Introduction to ArgoCD

ArgoCD is a declarative, GitOps continuous delivery tool, primarily designed for Kubernetes environments. It allows users to maintain desired application states in Git repositories and automatically syncs with the live environment.

Atlantis listens for GitHub webhooks and applies Terraform plans to the desired infrastructure. Here's an example of how to use Atlantis:

- name: Atlantis Terraform
 uses: atlantis/gh-action@master
 with:
    atlantis-url: 'http://my-atlantis-url.com'

ArgoCD on the other hand automates the deployment of Kubernetes manifests by comparing the desired state with the current state. Here's an example of how to use ArgoCD:

- name: ArgoCD Deployment

Installation Guide: Atlantis

Atlantis facilitates pull request-driven workflows, simplifies Terraform collaboration, and supports stateful Terraform operations

a. Create a new directory for Atlantis and navigate to it:

mkdir atlantis && cd atlantis

b. Download the latest version of Atlantis for your operating system:

wget https://github.com/runatlantis/atlantis/releases/download/v0.16.1/atlantis_linux_amd64.zip

c. Unzip the downloaded file:

unzip atlantis_linux_amd64.zip

d. Make the atlantis binary executable:

chmod +x atlantis

e. Create a ~/.atlantis.yaml file to store your configuration:

cat > ~/.atlantis.yaml <<EOL
2version: 3
3repos:
4- id: /.*/
5  allow_custom_workflows: true
6EOL

f. Run the atlantis server command:

./atlantis server --atlantis-url $ATLANTIS_URL --gh-user $GH_USER --gh-token $GH_TOKEN --repo-whitelist $REPO_WHITELIST --require-approval --repos $REPOS

Installation Guide: ArgoCD

ArgoCD is a declarative, GitOps-based Kubernetes deployment tool. It allows you to define your entire infrastructure and application state using YAML manifests, which can be version-controlled and automated.

Here is a step-by-step guide to install ArgoCD:

a. Add the ArgoCD Helm repository:

helm repo add argo https://argoproj.github.io/argo-helm

b. Update your Helm repositories:

helm repo update

c. Install the ArgoCD Helm chart:

helm install argocd argo/argo-cd --create-namespace --namespace argocd

d. Get the initial password for the admin user:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

e. Expose the ArgoCD API server:

kubectl port-forward svc/argocd-server -n argocd 8080:443

f. Log in to the ArgoCD API server using the initial password:

DownloadCopy code1argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD

g. Change the password for the admin user:

argocd account update-password --current-password $ARGOCD_PASSWORD --new-password $NEW_ARGOCD_PASSWORD

After setting up either Atlantis or ArgoCD, you can create GitHub Actions workflows to trigger Terraform plan and apply actions.

For Atlantis, you can use the following sample workflow:

name: Atlantis

on:
 pull_request:
    branches:
      - main
 push:
    branches:
      - main

jobs:
 plan:
    name: Terraform Plan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          path: .
      - name: Terraform Plan
        uses: appleboy/terraform-action@master
        with:
          tf_actions_version: 0.13.0
          tf_plan_file: atlantis-plan
          tf_actions_comment: true
          tf_actions_repo_token: ${{ secrets.GITHUB_TOKEN }}
          tf_actions_auto_apply: false

For ArgoCD, you can use the following sample workflow:

name: ArgoCD

on:
 push:
    branches:
      - main

jobs:
 deploy:
    name: Deploy using ArgoCD
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: ArgoCD Kustomize Build
        run: |
          mkdir -p overlays/prod
          echo "resources:" > overlays/prod/kustomization.yaml
          echo "- ../../k8s" >> overlays/prod/kustomization.yaml
          echo "namePrefix: prod-" >> overlays/prod/kustomization.yaml

      - name: ArgoCD Kustomize Deployment
        run: |
          kubectl kustomize overlays/prod > overlays/prod/all.yaml
          curl -H "Content-Type: application/yaml" -X POST --data-binary "@overlays/prod/all.yaml" http://localhost:8080/api/v1/applications/default/terraform-sample-app/sync
        env:
          KUBECONFIG: ${{ secrets.KUBECONFIG }}
        needs: deploy-argocd

 deploy-argocd:
    name: Deploy ArgoCD using ArgoCD
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          path: .

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Build and load Docker image
        uses: docker/build-push-action@v2
        with:
          context: .
          push: true
          tags: myregistry/my-argocd-image:latest

      - name: Install ArgoCD using Kustomize
        run: |
          kubectl apply -k overlays/prod
        env:
          KUBECONFIG: ${{ secrets.KUBECONFIG }}

Comparative Analysis

To evaluate which tool is more suitable for your team, you can compare their features based on your requirements.

Environment Isolation

Feature

Atlantis

ArgoCD

Separate Environments

✔️

✔️

Feature Branches

✔️

✔️

Security and Access Control

Feature

Atlantis

ArgoCD

Access Control

✔️

✔️

Secret Management

❌

✔️

Testing and Continuous Integration

Feature

Atlantis

ArgoCD

Automated Testing

✔️

✔️

CI Pipelines

✔️

✔️

Monitoring and Observability

Feature

Atlantis

ArgoCD

Monitoring Integration

❌

✔️

Alerting and Notifications

❌

✔️

Consider factors such as access control, secret management, and observability features to determine what is best for your team. While both tools are powerful and efficient, they may differ in the specific capabilities they offer to suit your unique needs.

Learning Curve and Availability of Support

Feature

Atlantis

ArgoCD

Learning Curve

Moderate

Steeper

Support Availability

Community Support

Enterprise Support

Atlantis has a moderate learning curve due to its unique workflow, which might require some time to adapt. ArgoCD, on the other hand, has a steeper learning curve because it follows a different approach to managing Kubernetes applications.

ArgoCD offers better support with its Enterprise Support plan, while Atlantis relies on community support. The choice of support should also depend on the size and complexity of your organization.

Both Atlantis and ArgoCD offer powerful GitOps solutions for Terraform workflows. The choice between them depends on the project's requirements, if you require simplicity and your primary goal is direct Terraform integration, then Atlantis would be your go-to tool. Its focused nature aligns well with projects that primarily revolve around Terraform workflows without intricate Kubernetes dependencies. For projects with Kubernetes-centric architectures or those requiring advanced GitOps features for multi-environment scenarios, ArgoCD is the preferred solution. Its native support for Kubernetes and robust visualization capabilities make it well-suited for complex infrastructures.

Basically, the right choice depends on your project's specific needs and environment. Evaluate each tool based on its strengths and how well it aligns with your infrastructure and workflow goals.