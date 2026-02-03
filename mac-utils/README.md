# 🛠️ Macbook Utilitários

> **Desinstale apps completamente e limpe seu Mac em 1 clique ou 1 comando!**

[![macOS](https://img.shields.io/badge/macOS-10.14%2B-blue)](https://www.apple.com/macos)
[![Instalação](https://img.shields.io/badge/Instalação-1%20clique%20ou%201%20comando-green)](https://github.com/seu-usuario/mac-utils)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 🚀 Instalação (Escolha 1 das 2 opções)

### ✅ Opção 1: Instalador Clicável (Recomendado - Sem Terminal!)

**Perfeito para quem não quer usar linha de comando.**

1. 📥 [Baixe o instalador](https://github.com/seu-usuario/mac-utils/releases/latest/download/MacbookUtilitarios.pkg)
2. 🖱️ Clique duas vezes no arquivo `.pkg` baixado
3. ✅ Clique em "Continuar" e "Instalar"
4. 🎉 **Pronto!** Abra um novo terminal e use os comandos

**Tempo total:** 30 segundos | **Nível de dificuldade:** ⭐ (Muito fácil)

---

### ⚡ Opção 2: 1 Comando no Terminal (Para quem gosta de terminal)

**Copie, cole e aperte Enter:**

```bash
curl -fsSL https://raw.githubusercontent.com/seu-usuario/mac-utils/main/install.sh | bash
```

**Depois:**
```bash
source ~/.zshrc
```

**Tempo total:** 10 segundos | **Nível de dificuldade:** ⭐ (Muito fácil)

---

## 📱 O que você ganha?

Após instalar, abra o terminal e digite:

```bash
mac_help
```

**Vai mostrar todos os comandos disponíveis:**

| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `desinstalar` | Remove app + todos os arquivos escondidos | `desinstalar` (escolhe da lista) |
| `desinstalar Spotify` | Remove um app específico | `desinstalar "Google Chrome"` |
| `limpar-tudo` | Limpa caches, logs e libera espaço | `limpar-tudo` |
| `matar-porta 3000` | Libera uma porta em uso | `matar-porta 8080` |
| `listar-apps` | Mostra todos os apps instalados | `listar-apps --size` |

---

## 🎯 Exemplos Rápidos

### Desinstalar um app completamente (incluindo arquivos escondidos)

```bash
# Modo interativo - escolhe da lista
desinstalar

# Remove específico
desinstalar "Nome do App"

# Preview primeiro (mostra o que vai remover)
desinstalar-preview "Nome do App"
```

### Limpar o sistema

```bash
# Limpeza completa guiada
limpar-tudo

# Ou algo específico
limpar-caches      # Limpa caches por app
limpar-logs        # Remove logs antigos
limpar-lixeira     # Esvazia lixeira
```

### Desenvolvedores

```bash
# Liberar porta ocupada
matar-porta 3000

# Ver portas em uso
listar-portas

# Ver uso de disco
espaco-disco
```

---

## 🛡️ Segurança

✅ **100% seguro:**
- Arquivos vão para a **lixeira** (podem ser recuperados)
- **Nunca** remove arquivos do sistema (macOS, apps nativos)
- **Confirmação** antes de cada remoção
- **Preview** - você vê o que será removido antes

---

## ❌ Desinstalação

Mudou de ideia? [Clique aqui para ver como remover](UNINSTALL.md)

Ou execute no terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/seu-usuario/mac-utils/main/uninstall.sh | bash
```

---

## 🤔 Problemas?

### O comando não funciona?

1. Feche e abra o terminal novamente
2. Ou execute: `source ~/.zshrc`

### Quer ver todos os comandos?

```bash
mac_help
```

### Ainda com problemas?

[Abra uma issue no GitHub](../../issues) - respondemos rápido!

---

## 💝 Gratuito e Open Source

Este software é **100% gratuito** e [código aberto](LICENSE).

Se te ajudou, ⭐ **dê uma estrela** no repositório!

---

## 📞 Suporte

- 💬 [GitHub Discussions](../../discussions) - Tire dúvidas
- 🐛 [GitHub Issues](../../issues) - Reporte bugs

---

<p align="center">
  <strong>🎉 Feito para tornar seu Mac mais limpo e organizado!</strong>
</p>
