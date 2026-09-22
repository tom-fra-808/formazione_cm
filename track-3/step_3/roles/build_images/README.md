<h1 align="center">Ruolo: build_images</h1>

Questo ruolo costruisce le immagini dei container partendo dai file dello
Step 2, le pubblica nel registry locale e avvia i relativi container SSH
tramite Docker o Podman.

## Obiettivo

- preparare i contesti di build nella VM;
- copiare i `Containerfile` e la chiave pubblica SSH;
- costruire le immagini Ubuntu e Rocky dello Step 2;
- pubblicare le immagini nel registry locale;
- avviare i container SSH;
- gestire nomi, tag e porte tramite le variabili del ruolo.

## Funzionamento

Per ogni immagine, il ruolo crea un contesto di build nella VM e vi copia
il `Containerfile` e la chiave pubblica SSH.

In base al runtime selezionato da `runtime_detect`, costruisce l’immagine
con Docker o Podman e la pubblica nel registry locale. Successivamente
avvia il relativo container, esponendo la porta SSH sulla VM.

Con le variabili predefinite:

- Ubuntu utilizza `127.0.0.1:5000/ubuntu-ssh:22.04` e la porta `2222`;
- Rocky utilizza `127.0.0.1:5000/rocky-ssh:9` e la porta `2223`.

Le immagini contengono il server SSH, l’utente `genericuser`,
l’autenticazione tramite chiave pubblica e `sudo` senza password.

## Variabili

Le variabili predefinite si trovano in:

```text
track-3/step_3/roles/build_images/defaults/main.yml
```

Il file definisce:

- indirizzo del registry;
- directory remota dei contesti di build;
- percorso della chiave pubblica;
- nomi e tag delle immagini;
- percorsi dei `Containerfile`;
- porte SSH pubblicate sulla VM.

## Utilizzo

Il ruolo è richiamato da `site.yaml` dopo `runtime_detect` e
`container_registry`:

```yaml
roles:
  - role: runtime_detect
  - role: container_registry
  - role: build_images
```

Eseguire dalla radice del repository:

```bash
ansible-playbook track-3/step_3/site.yaml
```

## Verifica

Con Docker:

```bash
vagrant ssh registry -c 'sudo docker images'
vagrant ssh registry -c 'sudo docker ps'
```

Con Podman:

```bash
vagrant ssh registry -c 'sudo podman images'
vagrant ssh registry -c 'sudo podman ps'
```

Per controllare le immagini pubblicate nel registry:

```bash
curl http://192.168.58.10:5000/v2/_catalog
curl http://192.168.58.10:5000/v2/ubuntu-ssh/tags/list
curl http://192.168.58.10:5000/v2/rocky-ssh/tags/list
```

Il catalogo deve contenere `ubuntu-ssh` e `rocky-ssh`. Con le variabili
predefinite, i tag attesi sono rispettivamente `22.04` e `9`.

Il recap Ansible deve terminare con `unreachable=0` e `failed=0`.
