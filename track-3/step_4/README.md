<h1 align="center">Step 4: Ansible Vault</h1>

## Obiettivo

La traccia richiede di cifrare le password degli utenti nei Containerfile e le
credenziali del registry usando Ansible Vault. Ansible Vault permette di cifrare
variabili o file contenenti dati sensibili.

## Scelta fatta

Nella configurazione utilizzata non avevo password da cifrare nei Containerfile
o nelle variabili Ansible. **La creazione di un vault non era quindi necessaria
per questo esercizio.**

> [!NOTE]
> La chiave privata SSH rimane un dato sensibile: va custodita localmente e
> tenuta fuori dal repository.

## Come avrei utilizzato Vault

Se avessi avuto password da gestire, ad esempio per il login al registry, le
avrei inserite in un file di variabili cifrato con `ansible-vault` e richiamate
nei task tramite i nomi delle variabili.

Durante l'esecuzione del playbook avrei fornito la password di Vault per
decifrare quei dati. Questa password sarebbe stata distinta dalle credenziali
del registry contenute nel file.

## Comandi che avrei utilizzato

Creazione di un nuovo file cifrato:

```bash
ansible-vault create <file> --ask-vault-pass
```

Cifratura di un file già esistente:

```bash
ansible-vault encrypt <file> --ask-vault-pass
```

Visualizzazione del contenuto senza lasciarlo in chiaro sul disco:

```bash
ansible-vault view <file> --ask-vault-pass
```

Modifica del file cifrato:

```bash
ansible-vault edit <file> --ask-vault-pass
```

Decifratura del file:

```bash
ansible-vault decrypt <file> --ask-vault-pass
```

Per cifrare direttamente una singola variabile avrei usato:

```bash
ansible-vault encrypt_string 'password-del-registry' \
  --name 'registry_password' \
  --ask-vault-pass
```

Il comando restituisce un valore cifrato da inserire in un file YAML, ad
esempio:

```yaml
registry_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          ...
```

Infine, per eseguire un playbook che utilizza variabili cifrate, avrei usato:

```bash
ansible-playbook site.yaml --ask-vault-pass
```

In alternativa alla richiesta interattiva, avrei potuto usare un file protetto
contenente la password del Vault:

```bash
ansible-playbook site.yaml --vault-password-file ~/.vault
```

La password del Vault protegge il file cifrato; non è la password dell'utente
del container e non è la password del registry.
