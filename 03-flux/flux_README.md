` curl -s https://fluxcd.io/install.sh | sudo bash `

` flux bootstrap github --components-extra=image-reflector-controller,image-automation-controller --owner=nurembergwitch --repository=flux --branch=main --path=clusters/home --personal --token-auth `

Clone the created flux repo, cd into it. Here a monorepo approach is described; TBA - describe structure in detail.

` cd flux `
` mkdir -p default/home `

*manifest approach* Create a deployment for some demo app. Push the whole thing into the git repo. Flux will automatically deploy it. 

*helm approach* 
Create 2 crds: repository and release, refer to demo yamls in my flux dir. Flux will then check for chart updates.