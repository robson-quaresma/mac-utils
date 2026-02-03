# 🗑️ Desinstalação do Macbook Utilitários

Se você decidiu remover o Macbook Utilitários do seu sistema, siga os passos abaixo.

## ⚠️ Antes de Desinstalar

- **Seus aliases pararão de funcionar** nos terminais novos
- **Arquivos na lixeira** permanecem (o script só move para lá)
- **Backup automático** do seu `.zshrc` original foi criado durante a instalação

---

## 🚀 Método Rápido (Automático)

Criamos um script de desinstalação automática:

```bash
# Baixa e executa o desinstalador
curl -fsSL https://raw.githubusercontent.com/[seu-usuario]/macbook-utilitarios/main/uninstall.sh | bash
```

Ou manualmente:

```bash
# Clone o repositório (se ainda tiver)
cd macbook-utilitarios
chmod +x uninstall.sh
./uninstall.sh
```

---

## 📝 Método Manual

Se preferir fazer manualmente:

### Passo 1: Remover a linha do ~/.zshrc

```bash
# Edite o arquivo
nano ~/.zshrc

# Procure e remova esta linha:
# source ~/.mac-utils/macbook/macbook-utilitarios.sh

# Ou use sed para remover automaticamente:
sed -i '' '/macbook-utilitarios/d' ~/.zshrc
```

### Passo 2: Remover os arquivos

```bash
# Remove o diretório completo
rm -rf ~/.mac-utils/

# Ou apenas o script específico
rm -rf ~/.mac-utils/macbook/
```

### Passo 3: Recarregar o terminal

```bash
# Feche e abra um novo terminal
# Ou recarregue:
source ~/.zshrc
```

---

## 🔄 Restaurar .zshrc Original

Se você quer voltar ao `.zshrc` de antes da instalação:

```bash
# Liste os backups disponíveis
ls -la ~/.zshrc.backup.* 2>/dev/null

# Restaura o backup mais recente (substitua XXX pelo timestamp)
cp ~/.zshrc.backup.XXX ~/.zshrc

# Ou restaure todos os backups anteriores
# Cuidado: você perderá outras alterações feitas depois da instalação
```

---

## ✅ Verificação

Para confirmar que desinstalou corretamente:

```bash
# Tente um comando
mac_help

# Se retornar "command not found", está desinstalado!
```

---

## 🤔 Mudou de Ideia?

Se desinstalou por engano ou quer voltar a usar:

```bash
# Reinstale seguindo as instruções do README.md
curl -fsSL https://raw.githubusercontent.com/[seu-usuario]/macbook-utilitarios/main/install.sh | bash
```

---

## 💬 Precisa de Ajuda?

- **Issues:** [GitHub Issues](../../issues)
- **Discussions:** [GitHub Discussions](../../discussions)

---

Obrigado por ter usado o Macbook Utilitários! 🙏
