<h1 align="center">Ruolo: runtime_detect</h1>

Questo ruolo rileva il runtime per i container presente nella macchina gestita.
Nel laboratorio viene individuato Docker; la stessa logica permette di gestire
anche un host che utilizza Podman.

## Obiettivo

- controllare quali strumenti container sono disponibili;
- individuare il runtime da usare nei ruoli successivi;
- rendere il playbook indipendente dal runtime installato in precedenza.

## Funzionamento

Il ruolo verifica la presenza del comando e del servizio del runtime. In base al
risultato, rende disponibile l'informazione necessaria a `container_registry` e
`build_images`.

Il ruolo non costruisce immagini e non avvia container: prepara soltanto il
contesto che gli altri ruoli utilizzeranno.

## Variabili

Le variabili predefinite si trovano in:

```text
roles/runtime_detect/defaults/main.yml
```

Non sono richieste variabili obbligatorie per l'esecuzione standard del
laboratorio.

## Utilizzo

Il ruolo viene richiamato dal playbook principale:

```yaml
- name: Rileva il runtime
  ansible.builtin.include_role:
    name: runtime_detect
```

Eseguire dalla radice del progetto:

```bash
ansible-playbook track-3/step_3/site.yaml --syntax-check
ansible-playbook track-3/step_3/site.yaml
```

## Verifica

```bash
vagrant ssh registry -c 'sudo docker --version'
```

Il playbook deve terminare con `unreachable=0` e `failed=0`.
