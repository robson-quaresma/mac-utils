# 🛠️ Macbook Utilitários

> **Kit completo de utilitários para macOS via linha de comando**  
> Desinstalação segura de apps, limpeza inteligente do sistema e ferramentas para desenvolvedores - tudo em português e com máxima segurança!

[![macOS](https://img.shields.io/badge/macOS-10.14%2B-blue)](https://www.apple.com/macos)
[![Shell](https://img.shields.io/badge/Shell-ZSH-green)](https://www.zsh.org)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 📑 Índice

- [✨ Funcionalidades](#-funcionalidades)
- [🚀 Instalação](#-instalação)
- [📖 Como Usar](#-como-usar)
- [🛡️ Segurança](#️-segurança)
- [⚙️ Comandos Disponíveis](#️-comandos-disponíveis)
- [🤝 Contribuindo](#-contribuindo)
- [📄 Licença](#-licença)

---

## ✨ Funcionalidades

### 🗑️ **Desinstalação Completa de Apps**
- Remove o app **+ todos os arquivos residuais** (caches, preferências, logs)
- **Modo interativo**: Selecione múltiplos apps de uma só vez
- **Preview antes de deletar**: Veja exatamente o que será removido
- **100% seguro**: Arquivos vão para a lixeira (recuperáveis)
- **Proteção automática**: Nunca remove arquivos do sistema

### 🧹 **Limpeza Inteligente do Sistema**
- Limpeza seletiva de caches por aplicativo
- Remoção de logs antigos (>30 dias)
- Esvaziamento seguro da lixeira
- Limpeza de downloads antigos
- Manutenção do Homebrew (se instalado)
- Liberação de memória RAM

### 🛠️ **Utilitários para Desenvolvedores**
- Liberação de portas em uso (`matar-porta 3000`)
- Listagem de portas ocupadas
- Monitoramento de uso de disco
- Monitoramento de uso de memória

---

## 🚀 Instalação

### Método 1: Via curl (mais rápido)

```bash
# Baixa e executa o instalador
curl -fsSL https://raw.githubusercontent.com/[seu-usuario]/macbook-utilitarios/main/install.sh | bash

# Recarrega o terminal
source ~/.zshrc
```

### Método 2: Clone do repositório

```bash
# Clone o repositório
git clone https://github.com/[seu-usuario]/macbook-utilitarios.git

# Entra no diretório
cd macbook-utilitarios

# Executa o instalador
chmod +x install.sh
./install.sh

# Recarrega o terminal
source ~/.zshrc
```

### Método 3: Instalação manual

```bash
# Cria a estrutura de diretórios
mkdir -p ~/.mac-utils/macbook

# Copia o script
cp macbook-utilitarios.sh ~/.mac-utils/macbook/

# Adiciona ao ~/.zshrc
echo "source ~/.mac-utils/macbook/macbook-utilitarios.sh" >> ~/.zshrc

# Recarrega o terminal
source ~/.zshrc
```

✅ **Pronto!** Agora todos os comandos estão disponíveis.

---

## 📖 Como Usar

### 🎯 Primeiros passos

```bash
# Ver todos os comandos disponíveis
mac_help

# Listar todos os apps instalados
listar-apps

# Listar apps com tamanhos
listar-apps --size
```

### 🗑️ Desinstalar Aplicativos

#### Modo 1: Interativo (seleciona múltiplos apps)
```bash
desinstalar
```

**Saída esperada:**
```
📱 Modo Interativo de Desinstalação
────────────────────────────────────────────────────────────

Aplicativos instalados:
  1. Safari
  2. Spotify
  3. Google Chrome
  4. WhatsApp
  5. Zoom
  6. Visual Studio Code
  ...

Digite os números: 2,4,6
# ou: 1-3 (seleciona do 1 ao 3)
# ou: 2,4,7-10
```

#### Modo 2: App específico
```bash
# Desinstalar um app específico
desinstalar "Google Chrome"

# Preview (mostra o que será removido, mas não deleta)
desinstalar-preview "Google Chrome"
```

### 🧹 Limpar o Sistema

```bash
# Ver todas as opções de limpeza
limpar

# Limpeza completa (guiada passo a passo)
limpar-tudo

# Limpar algo específico
limpar-caches      # Limpa caches (seletivo)
limpar-logs        # Remove logs antigos
limpar-lixeira     # Esvazia lixeira
limpar-brew        # Limpa Homebrew
limpar-downloads   # Remove downloads antigos
```

### 🛠️ Utilitários Dev

```bash
# Ver portas em uso
listar-portas

# Liberar uma porta específica
matar-porta 3000
matar-porta 8080

# Ver uso de disco
espaco-disco

# Ver uso de memória
uso-memoria
```

---

## 🛡️ Segurança

### Por que é seguro?

| Recurso | Descrição |
|---------|-----------|
| 🗑️ **Lixeira primeiro** | Arquivos vão para a lixeira, não são deletados permanentemente |
| 👀 **Preview obrigatório** | Você vê exatamente o que será removido antes de confirmar |
| ✅ **Confirmações** | Sistema pergunta antes de cada ação importante |
| 🚫 **Proteção de sistema** | Ignora automaticamente `/System`, `/usr`, `/bin`, etc. |
| 🔍 **Verificação inteligente** | Só remove arquivos que realmente pertencem ao app |

### O que NUNCA será removido

- ✅ Sistema operacional (`/System`)
- ✅ Binários do sistema (`/usr`, `/bin`, `/sbin`)
- ✅ Frameworks globais (`/Library/Frameworks`)
- ✅ Fontes do sistema (`/Library/Fonts`)
- ✅ Arquivos sem verificação de nome

### Recuperação

Se remover algo por engano, simplesmente vá até a **Lixeira** no Finder e recupere os arquivos.

---

## ⚙️ Comandos Disponíveis

### 🗑️ Gerenciamento de Aplicativos

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `desinstalar` | Modo interativo (seleciona múltiplos) | `desinstalar` |
| `desinstalar <app>` | Remove app específico | `desinstalar "Google Chrome"` |
| `desinstalar-preview <app>` | Preview do que será removido | `desinstalar-preview Spotify` |
| `listar-apps` | Lista apps instalados | `listar-apps` |
| `listar-apps --size` | Lista com tamanhos | `listar-apps --size` |
| `listar-apps <filtro>` | Filtra por nome | `listar-apps Chrome` |

### 🧹 Limpeza do Sistema

| Comando | Descrição |
|---------|-----------|
| `limpar` | Mostra menu com opções de limpeza |
| `limpar-tudo` | Limpeza completa guiada passo a passo |
| `limpar-caches` | Limpa caches (modo seletivo) |
| `limpar-logs` | Remove logs antigos (>30 dias) |
| `limpar-lixeira` | Esvazia lixeira |
| `limpar-brew` | Limpa Homebrew (cleanup + autoremove) |
| `limpar-downloads` | Remove downloads antigos (>30 dias) |
| `limpar-memory` | Libera memória RAM inativa |

### 🛠️ Utilitários Dev

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `matar-porta <porta>` | Libera porta em uso | `matar-porta 3000` |
| `listar-portas` | Lista todas as portas em uso | `listar-portas` |
| `espaco-disco` | Mostra uso de disco | `espaco-disco` |
| `uso-memoria` | Mostra uso de memória | `uso-memoria` |

### ℹ️ Ajuda

| Comando | Descrição |
|---------|-----------|
| `mac_help` | Mostra todos os comandos disponíveis |

---

## 🔧 Solução de Problemas

### O comando não funciona

```bash
# Verifique se o script está carregado
grep "macbook-utilitarios" ~/.zshrc

# Se não estiver, adicione manualmente:
echo "source ~/.mac-utils/macbook/macbook-utilitarios.sh" >> ~/.zshrc

# Recarregue o terminal
source ~/.zshrc
```

### Erro de permissão

```bash
# Torne o script executável
chmod +x ~/.mac-utils/macbook/macbook-utilitarios.sh

# Recarregue
source ~/.zshrc
```

### Desinstalação não encontra o app

```bash
# Liste os apps para ver o nome exato
listar-apps | grep -i nome

# Use o nome exato (com aspas se tiver espaços)
desinstalar "Nome Exato Do App"
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Aqui está como você pode ajudar:

### Reportando Bugs

1. Verifique se o bug já não foi reportado em [Issues](../../issues)
2. Abra uma nova issue descrevendo:
   - Versão do macOS
   - Versão do script
   - Passos para reproduzir
   - Comportamento esperado vs atual

### Sugerindo Funcionalidades

1. Abra uma issue com o título `[FEATURE] Nome da funcionalidade`
2. Descreva claramente o problema que ela resolve
3. Explique como você gostaria que funcionasse

### Enviando Pull Requests

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça suas alterações
4. Teste em seu Mac
5. Commit (`git commit -m 'feat: nova funcionalidade'`)
6. Push para a branch (`git push origin feature/nova-funcionalidade`)
7. Abra um Pull Request

### Padrões de Código

- Mantenha compatibilidade com ZSH
- Sempre prefira mover para lixeira em vez de `rm -rf`
- Adicione confirmações para ações destrutivas
- Use nomes de funções com prefixo `_macutils_` para funções privadas
- Documente novos comandos no `mac_help`

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

```
MIT License

Copyright (c) 2024 Macbook Utilitários Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND...
```

---

## 🙏 Agradecimentos

- Comunidade open source por tornar isso possível
- Todos os contribuidores que ajudaram a melhorar este projeto
- Usuários de Mac que compartilharam suas necessidades

---

## 📞 Suporte

- **Issues:** [GitHub Issues](../../issues)
- **Discussions:** [GitHub Discussions](../../discussions)
- **Email:** seu-email@exemplo.com (opcional)

---

<p align="center">
  <strong>⭐ Star este repositório se te ajudou!</strong>
</p>

<p align="center">
  Feito com ❤️ para a comunidade Mac
</p>
