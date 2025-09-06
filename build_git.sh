git status
git add .
git commit -m "Init AI_O11y_Custos"

# garanta que a branch local se chame main
git branch -M main

# configure (ou confira) o remoto
git remote add origin https://github.com/mbenedicto99/AI_O11y_Custos.git 2>/dev/null || \
git remote set-url origin https://github.com/mbenedicto99/AI_O11y_Custos.git

# agora vai
git push -u origin main

