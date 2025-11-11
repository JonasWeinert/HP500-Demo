# HP500-Demo


## Lab 0: Git:
1. Open GitHub Desktop
2. Clone the repository to your computer (Remember the folder location)
3. Create a new branch based on main: Name it {Your Name Gets started}
4. Open the `Welcome.md` file in VS Code
5. Delete All text
6. Write a friendly message
7. Save in Vs Code
8. Commit & Push in GitHub Desktop
 Done 🎉

## Lab 1: Make the Demoproject run on your computer
 - Focus on point 1: Relative file references 
 - Open the *Demoproject* to get started
 1. Look at the folder and file structure
 2. Inspect the do files
 3. Change the paths and references to work on your **and any other** computer with minimal changes.

> [!TIP]
> In VS Code use the find & replace panel to easily overview and bulk-modify text changes.



## Lab 2: Apply more concepts and play with AI
- Open Github Copilot in VS Code
- If you haven't done so: Enable it as described [here](https://docs.github.com/en/copilot/get-started/quickstart)
- Try using it to work on some of the repository problems
- After using it initially:
1. Create a new file called `copilot-instructions.md` in the `.github` folder
2. Paste custom instructions. These are guidelines that the AI agent will always adhere to when you ask it to do something. You can paste something like:

```
You are a helpful research assistant. Make sure the code we produce together is always 
- modular
- minimal
- ...
```
> [!Tip]
> You can also copy & paste things from the [reproducibility checklist](https://github.com/JonasWeinert/HP500-Demo/blob/main/Reproducibility%20Checklist.md) to get started. 

This is very powerful. You can also set custom instructions for specific files/ subfolders, etc. See https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions for more info.

## Lab 3: Automated LaTeX Output Reports
- The `Demoproject` now includes an automated LaTeX report system
- Every push to `AI-coding` or `main` automatically compiles all outputs into a PDF
- The report includes:
  - Current date and git author
  - Recent commit messages
  - All analysis tables and figures
- View generated reports in the "Actions" tab → Download artifacts
- See `Demoproject/OUTPUTS_REPORT.md` for detailed documentation

# After the seminar: Resources to elevate our coding & reproducibility