<h1 align="center">Ruolo: container_registry</h1>

Questo ruolo configura un Docker Registry locale nella VM del laboratorio.
Utilizza l'immagine `registry:2` e rende disponibili le immagini sulla porta
`5000`.

## Obiettivo

- creare la directory per la persistenza dei dati;
- scaricare l'immagine del registry;
- creare e avviare il container del registry;
- mantenere i dati anche dopo la ricreazione del container.

## Funzionamento

Il ruolo prepara lo storage della VM e lo collega al percorso
`/var/lib/registry` del container. Il container viene avviato con una policy di
riavvio e con la porta `5000` pubblicata.

Il registry è senza autenticazione perché viene usato nella rete privata del
laboratorio.

## Variabili

Le variabili configurabili si trovano in:

```text
track-3/step_3/roles/container_registry/defaults/main.yml
```

Da questo file è possibile modificare, secondo la struttura del ruolo,
l'immagine, il nome del container, la porta e il percorso dello storage.

## Utilizzo

Il ruolo viene richiamato da `site.yaml` dopo `runtime_detect` e prima
di `build_images`:

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
vagrant ssh registry -c 'sudo docker ps --filter name=registry'
```

Con Podman:

```bash
vagrant ssh registry -c 'sudo podman ps --filter name=registry'
```

Verificare poi che l’API del registry risponda:

```bash
curl http://192.168.58.10:5000/v2/
```

Il container `registry` deve risultare in esecuzione e l’API deve
restituire una risposta corretta.
