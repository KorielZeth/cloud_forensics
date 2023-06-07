# Cloud Forensics mini-lab

This lab is (so far) a spin on chvancooten's CloudLabsAD (https://github.com/chvancooten/CloudLabsAD/) but with a Wazuh single stack instead of an Elastic one. I aim to iterate upon it by adding components to create a fully-fledged SIEM stack.

## Install instructions

Assuming that all commands are executed via the user's Azure Cloud Shell :

*   Create, within your Azure portal, a resource group in a region that is not yet used by other resources. Otherwise, the default subscription cap will be reached and you'll get an error message
*   Open your Cloud Shell, and clone this repository
*   Enter its `terraform` folder, and modify the `terraform.tfvars.example` file. The variables to modify are the resource group name, the IP whitelist (add the public IP of whatever subnet you're in), the domain name label, and the domain DNS name. Pay extra attention to this step, as any mis-input will cause the failure of the rest of the procedure
*   Once all of those have been properly modified, rename or copy this file, giving it the name `terraform.tfvars`
*   Launch (still within the `terraform` folder) the `terraform init` command
*   Once the terraform backend is properly initialized, launch the `terraform apply` command

Once the procedure is over, the various variables relevant to the lab's user will be displayed in the output (public IP of the lab, and Linux/Windows credentials). At the moment, the Wazuh credentials are not included within the output, so you must scroll sliiightly upwards in your Cloud Shell to get them (the relevant Ansible task is one of the last ones).

NAT-wise, everything is done via the public IP :
*   The Domain Controller is accessible via RDP on port 3390
*   The Windows client is accessible via RDP too, on port 3389
*   The attacker machine is accessible via SSH on port 22
*   And last but not least, the dedicated Wazuh stack machine is accessible via SSH on port 2222

In the event of an unforeseen Ansible task failure, the final Terraform output containing the aforementioned lab variables may not be displayed. Worry not, those are available at the very beginning of our command outputs, right after the initial validation, and will look like this :

```
random_string.windowspass: Creating...
random_string.windowspass: Creation complete after 0s [id=exemple]
random_string.linuxpass: Creating...
random_string.linuxpass: Creation complete after 0s [id=exemple]
```

## Marche à suivre

En partant du principe que toutes les commandes ci-dessous sont exécutées depuis la Cloud Shell de l'utilisateur :

*   Créez, dans le portail Azure, un groupe de ressource dans une région non-utilisée par d'autres ressources. Sinon, le cap de l'abonnement Azure par défaut sera atteint et un message d'erreur apparaîtra.
*   Se rendre dans la Cloud Shell, et cloner ce repo.
*   Se rendre dans le sous dossier `terraform`, et modifier le fichier `terraform.tfvars.example`. Les variables à modifier sont le nom du groupe de ressources, la whitelist d'ips (rajouter l'IP publique du sous-réseau sur lequel l'utilisateur se trouve), le label du nom de domaine, et le nom DNS du domaine. Attention, toute erreur ou conflit causera l'échec du reste de la procédure.
*   Une fois le fichier modifié, renommez/copiez le avec le nom `terraform.tfvars`
*   Lancez, toujours depuis le dossier `terraform`, la commande `terraform init`
*   Une fois le backend terraform initialisé, lancez la commande `terraform apply`


La procédure terminée, les différentes variables relatives au bon fonctionnement du lab seront affichées en tant qu'output (IP publique, identifiants et mots de passe Linux/Windows). Le mot de passe Wazuh ne sera pas malheureusement inclus dans cet output, il faudra donc remonter légèrement vers le haut afin de le récupérer (sa tâche Ansible étant une des dernières, affichée en jaune vif)

Au niveau connectivité; tout se fait via l'IP publique :
*   Le DC est accessible en RDP via le port 3390
*   Le client Windows est accessible lui aussi en RDP, via le port 3389
*   La machine d'attaque est accessible via SSH sur le port 22
*   La machine hébergeant le stack Wazuh est quand à elle disponible en SSH sur le port 2222

Malgré toutes les précautions prises, il se peut que l'installation du lab se finisse avec un échec sur une des tâches Ansible lambda, auquel cas les variables relatives au lab mentionnées plus haut ne seront pas affichés proprement : pas de panique, celles-ci sont visibles au tout début de l'output Terraform après la validation, sous la forme ci-contre : 

```
random_string.windowspass: Creating...
random_string.windowspass: Creation complete after 0s [id=exemple]
random_string.linuxpass: Creating...
random_string.linuxpass: Creation complete after 0s [id=exemple]
```