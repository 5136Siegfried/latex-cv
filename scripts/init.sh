#!/bin/bash

# === Variables ===
TEX_FILE="cv.tex"
VARS_FILE="vars.tex"
WORKFLOW_FILE=".github/workflows/build.yml"
DOCS_DIR="docs"
SCRIPTS_DIR="scripts"

# === Création des dossiers ===
echo "🛠️  Création des dossiers..."
mkdir -p "$DOCS_DIR" "$SCRIPTS_DIR" "$(dirname "$WORKFLOW_FILE")"

# === Fichier de variables ===
echo "📦 Création de $VARS_FILE..."
cat > "$VARS_FILE" <<'EOF'
% === Informations personnelles ===
\newcommand{\myname}{Siegfried Sekkai}
\newcommand{\myjob}{Ingénieur Cloud \& DevOps}
\newcommand{\mymail}{siegfried.sekkai@example.com}
\newcommand{\mygithub}{github.com/SiegfriedSekkai}
\newcommand{\mylocation}{Bordeaux, France}

% === Profil ===
\newcommand{\myprofil}{%
Ingénieur passionné par les systèmes résilients, l'automatisation intelligente, et les projets qui allient technique et engagement humain.
}
EOF

# === Fichier LaTeX principal ===
echo "📄 Création de $TEX_FILE..."
cat > "$TEX_FILE" <<'EOF'
\documentclass[a4paper,10pt]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{geometry}
\geometry{margin=1.5cm}
\usepackage{enumitem}
\usepackage{hyperref}
\usepackage{titlesec}
\usepackage{fontawesome}

\input{vars.tex}

\titleformat{\section}{\Large\bfseries}{}{0em}{}
\renewcommand{\labelitemi}{--}

\begin{document}

\begin{center}
    {\LARGE \textbf{\myname}} \\
    \href{mailto:\mymail}{\mymail} ~|~
    \href{https://\mygithub}{\mygithub} ~|~
    \mylocation
\end{center}

\vspace{0.5cm}

\section*{Profil}
\myprofil

\section*{Expérience}

\textbf{Architecte Cloud Freelance} \hfill 2023 – aujourd’hui \\
Travail sur des projets d’infrastructure scalable, GitOps, SRE, CI/CD.

\section*{Formations}

\textbf{Google Cybersecurity Professional Certificate} — Coursera \hfill 2025

\section*{Compétences}

\begin{itemize}[leftmargin=1.2em]
    \item DevOps : Docker, Kubernetes, GitLab CI, Terraform
    \item Cloud : AWS, GCP, Azure
    \item Observabilité : Prometheus, Grafana, ELK
    \item SecOps : Sécurité, PCA/PRA, gestion des secrets
\end{itemize}

\end{document}
EOF

# === Workflow GitHub Actions ===
echo "⚙️  Création de GitHub Action ($WORKFLOW_FILE)..."
cat > "$WORKFLOW_FILE" <<'EOF'
name: Build LaTeX CV

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Compile LaTeX document
        uses: xu-cheng/latex-action@v2
        with:
          root_file: cv.tex

      - name: Copy PDF to docs/
        run: |
          mkdir -p docs
          cp cv.pdf docs/

      - name: Commit and push PDF
        run: |
          git config user.name "github-actions"
          git config user.email "github-actions@github.com"
          git add docs/cv.pdf
          git commit -m "Update compiled CV"
          git push
EOF

# === README.md ===
echo "📝 Génération de README.md..."
cat > README.md <<EOF
# CV – Siegfried Sekkai

Ce dépôt contient mon CV en LaTeX.
Il est compilé automatiquement via GitHub Actions et publié sur GitHub Pages.

➡️ [Voir le CV en PDF](https://5136Siegfried.github.io/latex-cv/cv.pdf)

## Structure
- \`cv.tex\` : source LaTeX principal
- \`vars.tex\` : variables modifiables (infos personnelles)
- \`docs/\` : dossier de publication
- \`.github/workflows/\` : CI/CD pour la compilation LaTeX
EOF

# === Rendu exécutable ===
chmod +x "$0"

echo "✅ Initialisation terminée. Next Step :  commit et push !"