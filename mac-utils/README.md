# 🛠️ Macbook Utilitários

> **Desinstale apps completamente e limpe seu Mac com 1 comando!**

[![macOS](https://img.shields.io/badge/macOS-10.14%2B-blue)](https://www.apple.com/macos)
[![Instalação](https://img.shields.io/badge/Instalação-1%20comando-green)](https://github.com/seu-usuari/mac-utils)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 🚀 Instalação (1 Comando)

**Copie, cole no terminal e aperte Enter:**

```bash
curl -fsSL https://raw.githubusercontent.com/robson-quaresma/mac-utils/main/install.sh | bash
```

**Depois:**
```bash
source ~/.zshrc
```

**Pronto!** ✅

---

## 📱 Como Usar

### Ver todos os comandos disponíveis:

```bash
mac_help
```

### Principais comandos:

| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `desinstalar` | Modo interativo - escolhe apps da lista | `desinstalar` |
| `desinstalar "Nome do App"` | Remove um app específico | `desinstalar "Google Chrome"` |
| `limpar-tudo` | Limpa caches, logs e libera espaço | `limpar-tudo` |
| `matar-porta 3000` | Libera uma porta em uso | `matar-porta 8080` |
| `listar-apps` | Lista todos os apps instalados | `listar-apps` |

---

## 🎯 Exemplos Rápidos

### Desinstalar apps:

```bash
# Escolhe da lista interativa
desinstalar

# Remove app específico
desinstalar "Spotify"

# Ver o que será removido antes
desinstalar-preview "Nome do App"
```

### Limpar o sistema:

```bash
# Limpeza completa guiada
limpar-tudo

# Limpar algo específico
limpar-caches      # Limpa caches
limpar-logs        # Remove logs antigos
limpar-lixeira     # Esvazia lixeira
```

### Utilitários para desenvolvedores:

```bash
# Liberar porta ocupada
matar-porta 3000

# Ver portas em uso
listar-portas

# Ver espaço em disco
espaco-disco
```

---

## 🛡️ Segurança

✅ **100% seguro:**
- Arquivos vão para a **lixeira** (recuperáveis)
- **Nunca** remove arquivos do sistema (macOS, apps nativos)
- **Confirmação** antes de cada remoção
- **Preview** - você vê o que será removido antes

---

## 📦 Instalação Manual (Alternativa)

Se preferir, pode instalar manualmente:

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/mac-utils.git
cd mac-utils

# Execute o instalador
./install.sh

# Recarregue o terminal
source ~/.zshrc
```

---

## ❌ Desinstalação

Para remover o Macbook Utilitários:

```bash
curl -fsSL https://raw.githubusercontent.com/seu-usuario/mac-utils/main/uninstall.sh | bash
```

Ou manualmente:
- Remova a linha `source ~/.mac-utils/macbook/macbook-utilitarios.sh` do `~/.zshrc`
- Delete a pasta `~/.mac-utils/`

---

## 📁 Estrutura do Projeto

```
mac-utils/
├── macbook-utilitarios.sh    # Script principal
├── install.sh                # Instalador
├── uninstall.sh              # Desinstalador
├── README.md                 # Este arquivo
├── UNINSTALL.md              # Guia de desinstalação
└── LICENSE                   # Licença MIT
```

---

## 🆘 Problemas?

### O comando não funciona?

1. Feche e abra o terminal novamente
2. Ou execute: `source ~/.zshrc`

### Erro ao instalar?

Certifique-se de estar usando o **Terminal** ou **iTerm** com **ZSH** (padrão do macOS moderno).

### Ainda com problemas?

[Abra uma issue no GitHub](../../issues)

---

## 🤝 Contribuindo

Contribuições são bem-vindas!

1. Fork o repositório
2. Crie sua branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'feat: nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).

---

## 💝 Gratuito e Open Source

Este software é **100% gratuito** e código aberto.

Se te ajudou, ⭐ **dê uma estrela** no repositório!

---

<p align="center">
  <strong>🎉 Feito para tornar seu Mac mais limpo e organizado!</strong>
</p>
