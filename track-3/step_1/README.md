<h1 align="center">Step 1: Docker Registry con Ansible</h1>

<p align="center">
  Laboratorio DevOps con Vagrant, Debian 12, Ansible e Docker.
</p>

In questo step ho configurato un Docker Registry locale su una VM Debian 12.
Ansible installa e avvia Docker, poi crea il container `docker-registry` usando
l'immagine `registry:2`.

Il registry è raggiungibile in HTTP su `192.168.58.10:5000`, senza autenticazione.
Le immagini vengono conservate nella directory `/var/lib/registry` della VM,
montata nel container per mantenere i dati anche dopo la sua ricreazione.

## File utilizzati

I percorsi sono relativi alla radice di `formazione_cm`.

| File | Funzione |
| --- | --- |
| `Vagrantfile` | Crea la VM `registry` con IP `192.168.58.10` |
| `inventory.ini` | Definisce l'host `registry`, l'utente `vagrant` e la chiave SSH |
| `ansible.cfg` | Imposta l'inventario da utilizzare |
| `track-3/step_1/requirements.yml` | Installa la collection `community.docker` |
| `track-3/step_1/container-playbook.yaml` | Installa Docker e avvia il registry |

## Avvio

Sul Mac servono Vagrant, VirtualBox, Ansible e `curl`.

Dalla radice del progetto, installa la collection usata dal playbook:

```bash
cd ~/Desktop/formazione_cm
ansible-galaxy collection install -r track-3/step_1/requirements.yml
```

Avvia la VM ed esegui il playbook:

```bash
vagrant up registry
ansible-playbook track-3/step_1/container-playbook.yaml
```

Il recap deve terminare con `unreachable=0` e `failed=0`.

## Verifica

Controlla che il container sia avviato e che l'API risponda:

```bash
vagrant ssh registry -c 'sudo docker ps --filter name=docker-registry'
curl -i http://192.168.58.10:5000/v2/
```

Il container deve risultare `Up` e la richiesta HTTP deve restituire `200 OK`.

Per provare push e pull, esegui i comandi Docker nella VM:

```bash
vagrant ssh registry
sudo docker pull busybox:latest
sudo docker tag busybox:latest localhost:5000/lab/busybox:v1
sudo docker push localhost:5000/lab/busybox:v1
sudo docker pull localhost:5000/lab/busybox:v1
exit
```

Dal Mac puoi vedere le immagini pubblicate e i loro tag:

```bash
curl http://192.168.58.10:5000/v2/_catalog
curl http://192.168.58.10:5000/v2/lab/busybox/tags/list
```

Il catalogo deve contenere `lab/busybox` e il relativo elenco dei tag deve
includere `v1`. Possono essere presenti anche le immagini degli step successivi.

Rieseguendo il playbook senza modifiche, il recap dovrebbe riportare `changed=0`:
questo verifica l'idempotenza.
