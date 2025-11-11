# LaTeX Outputs Report - Quick Start Guide

## 🚀 What You Get

Every time you push to `AI-coding` or `main` branch, a beautiful PDF report is automatically generated containing:
- ✅ All your analysis tables
- ✅ All your figures
- ✅ Git metadata (date, author, recent commits)
- ✅ Professional formatting with table of contents

## 📥 How to Access the PDF

### Method 1: GitHub Actions (Recommended)
1. Go to your repository on GitHub
2. Click the **"Actions"** tab at the top
3. Click on the latest workflow run (should be green ✓)
4. Scroll down to **"Artifacts"**
5. Download **"outputs-report-pdf"**
6. Unzip and open the PDF

### Method 2: From Releases (main branch only)
1. Go to the **"Releases"** section on GitHub
2. Look for the "latest" release
3. Download `outputs_report.pdf`

## 🎯 The Workflow is Triggered By

- Any push to the `AI-coding` branch
- Any push to the `main` branch
- Commits, merges, or direct pushes all work!

## 📝 What Gets Included Automatically

### Tables (from `outputs/tables/`)
- Table1a.tex
- Table1b.tex  
- TableE1.tex

### Figures (from `outputs/figures/`)
All PDF figures are automatically included and organized by theme:
- Attitudes (existing and new)
- Knowledge (existing, new, CL, HH)
- Legitimacy (existing, new, combined)
- Impartiality (existing, new, versions 1 & 2, combined)
- Procedures (existing, new, combined)
- Problem Management (versions 1 & 2, combined)
- Contact patterns (CL, HH)
- Independence from government

## 🔧 Customizing the Report

### Adding a New Output

1. Generate your new output file (figure or table) in the appropriate folder
2. Edit `outputs_report.tex`
3. Add your new figure/table in the appropriate section:

```latex
\subsection{My New Analysis}
\begin{figure}[H]
\centering
\includegraphics[width=0.8\textwidth]{my_new_figure.pdf}
\caption{Description of what this shows}
\label{fig:my_label}
\end{figure}
```

4. Commit and push - the PDF will update automatically!

### Changing Which Branches Trigger Compilation

Edit `.github/workflows/compile-latex.yml`:

```yaml
on:
  push:
    branches:
      - AI-coding    # Add or remove branches here
      - main
      - your-branch-name
```

## 🐛 Troubleshooting

### "My workflow failed!"
- Check the Actions tab for error messages
- Most common issue: Missing or incorrectly named figure files
- Verify all files referenced in the .tex file exist in `outputs/`

### "I don't see the artifact"
- Wait for the workflow to complete (green checkmark)
- Artifacts are available for 90 days after generation
- Only successful builds produce artifacts

### "The PDF looks wrong"
- LaTeX needs exact file names (case-sensitive!)
- Check that table .tex files have valid LaTeX syntax
- Try compiling locally first: `cd Demoproject && pdflatex outputs_report.tex`

### "Commits aren't showing up"
- Git metadata is only injected during the GitHub Action
- Local compilations will show placeholder text
- This is normal and expected!

## 📊 What the Workflow Does Behind the Scenes

1. **Checks out your code** with full git history
2. **Extracts metadata**:
   - Current date and time
   - Your git username
   - All commit messages from the push
3. **Injects metadata** into the LaTeX file (replaces placeholders)
4. **Compiles** the LaTeX document to PDF
5. **Uploads** the PDF as a downloadable artifact

## 💡 Pro Tips

- The workflow takes about 2-3 minutes to complete
- You can have multiple versions from different commits (check the commit SHA)
- The PDF includes clickable links in the table of contents
- All figures are embedded with high quality (not compressed)
- The report is completely self-contained

## 📚 More Information

- Full documentation: See `OUTPUTS_REPORT.md`
- LaTeX source: `outputs_report.tex`
- Workflow config: `.github/workflows/compile-latex.yml`
- Questions? Open an issue or contact the project maintainer

## 🎓 Learning Resources

If you want to customize the LaTeX:
- [LaTeX Wikibook](https://en.wikibooks.org/wiki/LaTeX) - Comprehensive guide
- [Overleaf Tutorials](https://www.overleaf.com/learn) - Interactive examples
- [LaTeX Stack Exchange](https://tex.stackexchange.com/) - Q&A community

---

**Happy researching! 📈📊📉**

