# 📦 Como Criar o Instalador Clicável (.pkg)

Este guia explica como criar um instalador `.pkg` para distribuir o Macbook Utilitários de forma que o usuário final só precise **clicar duas vezes** no arquivo.

## 🎯 Para quem é este guia?

**Você (desenvolvedor/distribuidor)** - Para criar o instalador que os usuários vão baixar.

**O usuário final NÃO precisa fazer isso!** Eles só baixam o arquivo `.pkg` pronto.

---

## 🚀 Método Super Rápido (1 comando)

Se você está na pasta `mac-utils/`:

```bash
# 1. Torne o script executável
chmod +x build-pkg.sh

# 2. Execute para criar o instalador
./build-pkg.sh
```

**Pronto!** O arquivo `MacbookUtilitarios-4.0.0.pkg` será criado na pasta.

---

## 📋 Requisitos

- macOS (este script só funciona no Mac)
- Xcode Command Line Tools (geralmente já vem instalado)

Se não tiver o Xcode Command Line Tools:
```bash
xcode-select --install
```

---

## 🎁 Distribuição

Após criar o instalador, você pode:

1. **GitHub Releases** (Recomendado)
   - Vá em Releases no seu repositório GitHub
   - Crie uma nova release
   - Anexe o arquivo `.pkg`
   - Usuários baixam direto do GitHub

2. **Seu site**
   - Hospede o arquivo `.pkg`
   - Link direto para download

3. **Compartilhamento direto**
   - Envie o arquivo para amigos/colaboradores

---

## ✅ Como o usuário vai instalar?

1. **Baixa** o arquivo `.pkg`
2. **Clica duas vezes** no arquivo
3. **Clica em "Continuar"** e "Instalar"
4. **Abre um novo terminal**
5. **Digita `mac_help`**

**Tempo total:** 30 segundos | **Nível de dificuldade:** ⭐ (Muito fácil)

---

## 🔄 Atualizando o Instalador

Quando lançar uma nova versão:

1. Edite `build-pkg.sh` e atualize a linha:
   ```bash
   VERSION="4.0.1"  # Nova versão
   ```

2. Execute novamente:
   ```bash
   ./build-pkg.sh
   ```

3. Publique o novo `.pkg` no GitHub Releases

---

## 🆘 Problemas?

### Erro: "pkgbuild não encontrado"

Instale o Xcode Command Line Tools:
```bash
xcode-select --install
```

### Erro de permissão

Torne o script executável:
```bash
chmod +x build-pkg.sh
```

---

## 📱 Diferença entre as opções de instalação

| Método | Para quem | Dificuldade | Tempo |
|--------|-----------|-------------|-------|
| **Instalador .pkg** | Usuários comuns | ⭐ Muito fácil | 30s |
| **curl \| bash** | Usuários técnicos | ⭐⭐ Fácil | 10s |
| **Git clone** | Desenvolvedores | ⭐⭐⭐ Médio | 2min |

**Recomendação:** Sempre ofereça o instalador `.pkg` como primeira opção!

---

## 💡 Dica Pro

Crie um QR Code para o link do instalador! Os usuários podem escanear e baixar direto no celular para enviar para o Mac.

---

**Pronto para distribuir!** 🚀
