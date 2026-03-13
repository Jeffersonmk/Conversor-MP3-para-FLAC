# FLAC → MP3 Batch Converter (Linux)

Um pequeno script que fiz **para uso pessoal** para converter minha biblioteca de músicas **FLAC para MP3** no Linux.

Resolvi colocar no GitHub caso seja útil para outras pessoas também.

Ele converte **pastas inteiras de FLAC**, mantendo **estrutura de diretórios**, **metadados**, e usando **todos os cores da CPU** para acelerar o processo.

---

## ✨ Features

* 🎧 Converte **FLAC → MP3**
* 📂 Mantém **estrutura de diretórios**
* 🏷️ Preserva **metadata (artist, album, etc.)**
* ⚡ Usa **todos os cores da CPU**
* ⏭️ **Pula arquivos já convertidos**
* 🐧 Funciona em praticamente qualquer distro Linux

---

## 📦 Dependências

O script depende de:

* **ffmpeg**
* **bash**
* **find**
* **xargs**

### Instalação

#### Arch / Manjaro

```bash
sudo pacman -S ffmpeg
```

#### Ubuntu / Debian

```bash
sudo apt install ffmpeg
```

#### Fedora

```bash
sudo dnf install ffmpeg
```

---

## 🚀 Uso

Primeiro torne o script executável:

```bash
chmod +x flac2mp3.sh
```

Depois execute:

```bash
./flac2mp3.sh pasta_flac pasta_mp3
```

### Exemplo

```bash
./flac2mp3.sh ~/Music/FLAC ~/Music/MP3
```

Estrutura original:

```
Music/
 └─ FLAC/
     └─ Artist/
         └─ Album/
             └─ track.flac
```

Resultado:

```
Music/
 └─ MP3/
     └─ Artist/
         └─ Album/
             └─ track.mp3
```

---

## ⚙️ Qualidade de áudio

O script usa:

```
-qscale:a 0
```

Isso gera **V0 VBR (~245 kbps)** usando **LAME**, que normalmente é considerado transparente para a maioria das pessoas.

Se quiser mudar a qualidade, edite essa linha no script.

Exemplos:

| Qualidade   | Opção         |
| ----------- | ------------- |
| Máxima VBR  | `-qscale:a 0` |
| Alta VBR    | `-qscale:a 2` |
| 320kbps CBR | `-b:a 320k`   |

---

## ⚡ Performance

O script detecta automaticamente quantos cores sua CPU tem:

```bash
THREADS=$(nproc)
```

E converte vários arquivos ao mesmo tempo usando:

```bash
xargs -P
```

Isso ajuda bastante ao converter **bibliotecas grandes de música**.

---

## 🧠 Observação

Este script foi feito **principalmente para resolver uma necessidade pessoal**, então ele é simples e direto.
Se você quiser modificar ou melhorar, fique à vontade.

---

## 📄 Licença

MIT License
