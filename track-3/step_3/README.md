<h1 align="center">Step 3: Ruoli Ansible e Docker</h1>

<p align="center">
  Laboratorio DevOps con Ansible, ruoli riutilizzabili e Docker.
</p>

In questo step ho organizzato la configurazione del registry e la costruzione
delle immagini Docker attraverso ruoli Ansible. Il playbook principale è
`site.yaml`.

## Obiettivo

- rilevare il runtime disponibile, Docker o Podman;
- configurare un Docker Registry locale;
- costruire le immagini dei container dello Step 2;
- riutilizzare le stesse attività tramite ruoli Ansible.

## Struttura

| File o directory | Funzione |
| --- | --- |
| `requirements.yml` | Collection Ansible necessarie |
| `site.yaml` | Playbook principale |
| `roles/runtime_detect` | Rileva il runtime container disponibile |
| `roles/container_registry` | Configura e avvia il registry |
| `roles/build_images` | Copia i contesti e costruisce le immagini |

Il playbook utilizza l'inventario e la configurazione presenti nella radice
del progetto:

```text
inventory.ini
ansible.cfg
```

La VM utilizzata è `registry`, raggiungibile all'indirizzo
`192.168.58.10`.

## Ruoli Ansible

### `runtime_detect`

Questo ruolo controlla quale runtime per i container è disponibile nella VM.
Nel laboratorio il runtime utilizzato è Docker, ma il ruolo permette di non
scrivere il playbook assumendo in anticipo una sola tecnologia. Il risultato
della rilevazione viene usato dagli altri ruoli per eseguire i comandi e i
moduli corretti.

### `container_registry`

Questo ruolo prepara il Docker Registry locale. Crea la directory destinata ai
dati, scarica l'immagine `registry:2` e avvia il container sulla porta `5000`.
Il registry viene configurato senza autenticazione perché è utilizzato
soltanto nella rete privata del laboratorio.

La persistenza è ottenuta collegando la directory della VM al percorso
`/var/lib/registry` del container. In questo modo le immagini restano
disponibili anche se il container del registry viene ricreato.

### `build_images`

Questo ruolo gestisce la costruzione delle immagini dello Step 2. Copia nella
VM i contesti di build, composti dal `Containerfile` e dai file necessari,
quindi usa il runtime rilevato per costruire le immagini.

Le immagini mantengono i requisiti dello Step 2: accesso SSH con
`genericuser`, autenticazione tramite chiave pubblica e privilegi `sudo` senza
password. I nomi, i contesti e i tag vengono gestiti dalle variabili del ruolo,
così la stessa struttura può essere riutilizzata per più immagini.

### `site.yaml`

`site.yaml` è il punto di ingresso del laboratorio. Richiama i tre ruoli e ne
coordina l'esecuzione: prima viene rilevato il runtime, poi viene configurato
il registry e infine vengono costruite le immagini.

Questa organizzazione separa le responsabilità: ogni ruolo svolge un compito
specifico e può essere modificato o riutilizzato senza dover riscrivere tutto
il playbook.

## Avvio

Dalla radice di `formazione_cm` installo le collection richieste:

```bash
ansible-galaxy collection install -r track-3/step_3/requirements.yml
```

Controllo la sintassi ed eseguo il playbook:

```bash
ansible-playbook track-3/step_3/site.yaml --syntax-check
ansible-playbook track-3/step_3/site.yaml
```

Il recap deve terminare con:

```text
unreachable=0 failed=0
```

## Verifica

Controllo che Docker e il registry siano attivi nella VM:

```bash
vagrant ssh registry -c 'sudo systemctl is-active docker'
vagrant ssh registry -c 'sudo docker ps'
```

Controllo le immagini costruite:

```bash
vagrant ssh registry -c 'sudo docker images'
```

Il registry deve essere esposto sulla porta `5000` e le immagini definite nelle
variabili del ruolo `build_images` devono risultare presenti.

## Idempotenza

Eseguendo nuovamente il playbook senza modifiche, Ansible deve lasciare il
sistema nello stesso stato e il numero di attività `changed` dovrebbe ridursi.
