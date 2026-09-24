# [TRACK 3] Configuration Management
Include:
- step della track 3
  - step 1: Creazione di un registry locale tramite un playbook [container-playbook](track-3/step_1/container-playbook.yaml) ([DOCUMENTAZIONE](track-3/step_1/README.md))
  - step 2: Creazione tramite Ansible di due container con os differenti. I container devono essere in ascolto sulla 22, devono avere attivo il servizio ssh e avere un utente abilitato a connettersi tramite ssh key e con poteri sudo. [playbook](track-3/step_2/2-cont.yml) ([DOCUMENTAZIONE](track-3/step_2/README.md)) 
  - step 3: Creazione di ruoli Ansible per configurare il registry, costruire e pubblicare due immagini e avviare i container usando Docker o Podman. [playbook](track-3/step_3/site.yaml) ([DOCUMENTAZIONE](track-3/step_3/README.md))
  - step 4: Gestione dei dati sensibili con Ansible Vault: spiegazione della scelta adottata e dei comandi da usare se vengono introdotte password. [DOCUMENTAZIONE](track-3/step_4/README.md)
  - step 5: Pipeline Jenkins per build, push sul registry e deploy tramite Ansible nel container con Docker interno. [Jenkinsfile](track-3/step_5/Jenkinsfile) ([DOCUMENTAZIONE](track-3/step_5/README.md))