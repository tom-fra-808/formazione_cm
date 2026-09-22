<h1 align="center">Step 5: Jenkins & Ansible</h1>

<p align="center">
  Build, push e deploy automatico di un'immagine tramite Jenkins e Ansible.
</p>

In questo step Jenkins costruisce un'immagine, la pubblica nel registry locale e utilizza Ansible per eseguirne il deploy nel container `deploy-target`.

> [!IMPORTANT]
> **Prerequisiti**
>
> * La VM `registry` deve essere avviata.
> * Il registry locale deve essere in esecuzione.
> * Lo Step 2 deve essere stato completato.
> * L’agent Jenkins `agent-docker`, con label `docker-ansible`, deve essere disponibile.
> * In Jenkins deve esistere la credenziale SSH `deploy-ssh`.
> * Le collection indicate nel file `requirements.yml` devono essere installate.

## Obiettivo

* creare il container `deploy-target` con SSH e Docker;
* costruire l’immagine Ubuntu tramite Jenkins;
* utilizzare `BUILD_NUMBER` come tag;
* pubblicare l’immagine nel registry locale;
* eseguire il deploy tramite Ansible;
* avviare o aggiornare il container `ubuntu-deploy`.

## Flusso

```text
Jenkins agent
→ build dell’immagine
→ push nel registry
→ Ansible via SSH
→ deploy-target
→ Docker interno
→ ubuntu-deploy
```

Il Docker Engine principale della VM esegue Jenkins, l’agent, il registry e `deploy-target`.

Il container `deploy-target` esegue un Docker Engine interno, utilizzato come ambiente di destinazione del deploy.

## Struttura

| Percorso                       | Funzione                                        |
| ------------------------------ | ----------------------------------------------- |
| `files/Containerfile`          | Costruisce l’immagine `deploy-target:1.0`       |
| `files/docker-entrypoint.sh`   | Avvia SSH e il Docker Engine interno            |
| `files/id_key_genericuser.pub` | Abilita l’accesso SSH                           |
| `dockerindocker.yml`           | Costruisce e avvia `deploy-target`              |
| `prep-agent.yml`               | Copia nell’agent i file necessari alla pipeline |
| `Jenkinsfile`                  | Definisce le fasi Build, Push e Deploy          |
| `deploy.yml`                   | Esegue il deploy nel Docker interno             |

La chiave privata non deve essere salvata nel repository.

## Preparazione

Eseguire dalla radice del repository:

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook track-3/step_5/dockerindocker.yml
ansible-playbook track-3/step_5/prep-agent.yml
```

Il primo playbook crea `deploy-target` e pubblica la sua porta SSH sulla porta `2224` della VM.

Il secondo prepara nell’agent Jenkins il contesto di build dello Step 2 e il playbook `deploy.yml`.

## Credenziale Jenkins

Configurare in Jenkins una credenziale con questi valori:

```text
Tipo: SSH Username with private key
ID: deploy-ssh
Username: genericuser
```

La chiave privata deve corrispondere alla chiave pubblica presente in:

```text
track-3/step_5/files/id_key_genericuser.pub
```

## Pipeline

La pipeline viene eseguita sull’agent con label `docker-ansible` e comprende tre fasi:

1. **Build**: costruisce l’immagine Ubuntu usando `BUILD_NUMBER` come tag.
2. **Push**: pubblica l’immagine nel registry locale.
3. **Deploy**: esegue `deploy.yml` tramite SSH verso `deploy-target`.

Avviare il job Jenkins con **Build Now**.

La pipeline deve terminare con:

```text
Finished: SUCCESS
```

## Verifica

Controllare che `deploy-target` sia in esecuzione:

```bash
vagrant ssh registry -c \
  'sudo docker ps --filter name=deploy-target'
```

Controllare il container distribuito nel Docker interno:

```bash
vagrant ssh registry -c \
  'sudo docker exec deploy-target docker ps --filter name=ubuntu-deploy'
```

Controllare i tag pubblicati nel registry:

```bash
curl http://192.168.58.10:5000/v2/ubuntu-ssh/tags/list
```

Il container `ubuntu-deploy` deve utilizzare l’immagine con il tag corrispondente all’ultimo `BUILD_NUMBER`.
