# === Variables ===
TEX=cv.tex
PDF=$(TEX:.tex=.pdf)

# === Cibles ===

all: $(PDF)

$(PDF): $(TEX) vars.tex
	@echo "📦 Compilation de $(TEX)..."
	pdflatex -interaction=nonstopmode $(TEX) > /dev/null

install:
	@echo "🔍 Vérification de l'installation de LaTeX..."
	@if command -v pdflatex > /dev/null; then \
		echo '✅ LaTeX est déjà installé.'; \
	else \
		echo '🚨 LaTeX n’est pas installé. Tentative d’installation...'; \
		if [ "$(shell uname)" = "Linux" ]; then \
			sudo apt update && sudo apt install -y texlive-full; \
		elif [ "$(shell uname)" = "Darwin" ]; then \
			brew install --cask mactex; \
			echo '➡️  Une fois installé, ajoutez /Library/TeX/texbin à votre PATH si besoin.'; \
		else \
			echo "❌ OS non pris en charge automatiquement. Installez LaTeX manuellement."; \
		fi \
	fi


clean:
	@echo "🧹 Nettoyage des fichiers auxiliaires..."
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz

open: $(PDF)
	@echo "📂 Ouverture du PDF..."
	xdg-open $(PDF) &> /dev/null || open $(PDF)

rebuild: clean all

.PHONY: all clean open rebuild