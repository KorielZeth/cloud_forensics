# Cloud Forensics mini-lab

Spin on chvancooten's CloudLabsAD (https://github.com/chvancooten/CloudLabsAD/) but with a Wazuh single stack instead of an Elastic one.

## Install instructions

To paraphrase M. Van Cooten's original README

    Clone the repo to your Azure cloud shell.
    Copy `terraform.tfvars.example` to `terraform.tfvars` in the Terraform directory, and configure the variables appropriately.
    In the same directory, run `terraform init`
    When you're ready to deploy, run `terraform apply` (or `terraform apply --auto-approve` to skip the approval check).

    Once done with the lab, run `terraform destroy`


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