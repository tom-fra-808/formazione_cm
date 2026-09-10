<h1 align="center">Ruolo: build_images</h1>

Questo ruolo costruisce le immagini Docker partendo dai contesti dello Step 2.
Gestisce il trasferimento dei file nella VM e l'esecuzione delle build tramite
il runtime rilevato.

## Obiettivo

- preparare i contesti di build nella VM;
- copiare `Containerfile` e chiavi pubbliche necessarie;
- costruire le immagini Ubuntu e Rocky dello Step 2;
- mantenere nomi e tag definiti nelle variabili del ruolo.

## Funzionamento

Per ogni immagine il ruolo copia il relativo contesto nella macchina gestita e
avvia la build. Le immagini create contengono il server SSH, l'utente
`genericuser`, l'accesso tramite chiave pubblica e `sudo` senza password.

Il ruolo usa il runtime individuato da `runtime_detect`, così la procedura resta
riutilizzabile anche quando il motore container cambia.

## Variabili

Le variabili del ruolo si trovano in:

```text
roles/build_images/defaults/main.yml
```

Qui sono definiti i contesti, i nomi delle immagini, i tag e i percorsi usati
dalla build.

## Utilizzo

Il ruolo viene richiamato dal playbook principale dopo la configurazione del
registry:

```yaml
- name: Costruisce le immagini
  ansible.builtin.include_role:
    name: build_images
```

Eseguire dalla radice del progetto:

```bash
ansible-playbook track-3/step_3/site.yaml
```

## Verifica

```bash
vagrant ssh registry -c 'sudo docker images'
```

Le immagini definite nelle variabili del ruolo devono essere presenti e il
recap Ansible deve terminare con `unreachable=0` e `failed=0`.
