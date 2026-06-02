# Passo a Passo para Deploy do Rails no Render

Este guia explica como fazer o deploy deste projeto no Render de forma simples e direta.

---

## 1. Preparar o Repositório no Git

Antes de começar no painel do Render, certifique-se de enviar as alterações que fizemos para o seu repositório Git (GitHub ou GitLab):

```bash
# Adicione os arquivos alterados
git add config/database.yml bin/render-build.sh

# Faça o commit
git commit -m "Configurações para deploy no Render"

# Envie para o GitHub/GitLab
git push origin main
```

*(Caso sua branch principal tenha outro nome, substitua `main` pelo nome dela, como `master`).*

---

## 2. Criar o Banco de Dados PostgreSQL no Render

Se você já criou o banco de dados no Render, pode pular esta etapa. Caso contrário:

1. Acesse o painel do [Render](https://dashboard.render.com/).
2. Clique em **New** (Novo) no topo superior direito e selecione **PostgreSQL**.
3. Preencha as informações:
   - **Name**: `projeto-transportadora-db` (ou o nome que preferir).
   - **Database**: `projeto_transportadora`
   - **User**: `projeto_transportadora`
   - **Region**: Selecione uma região próxima a você (ou a mesma onde criará o Web Service).
4. Selecione o plano gratuito (**Free**).
5. Clique em **Create Database**.
6. Assim que for criado, localize e copie a **Internal Connection String** (ex: `postgres://projeto_transportadora:senha@dpg-xxx:5432/projeto_transportadora`). Ela será usada no passo a seguir.

---

## 3. Criar o Web Service no Render

Agora vamos criar o servidor que vai rodar o código do Rails:

1. No painel do Render, clique em **New** (Novo) e selecione **Web Service**.
2. Escolha **Connect a repository** e selecione o repositório deste projeto.
3. Preencha as configurações básicas:
   - **Name**: `projeto-transportadora`
   - **Language**: `Ruby`
   - **Branch**: `main` (ou a branch que você enviou as alterações).
   - **Region**: A mesma região em que você criou o banco PostgreSQL.
4. Preencha as configurações de Build e Execução:
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `bundle exec puma -C config/puma.rb`
5. Escolha a opção de plano gratuito (**Free**).

---

## 4. Configurar as Variáveis de Ambiente

Antes de clicar em criar, role a página até a seção **Advanced** ou clique no botão para adicionar variáveis de ambiente:

Adicione as seguintes variáveis:

1. **`DATABASE_URL`**:
   - Cole a **Internal Connection String** do seu banco PostgreSQL que você copiou no Passo 2.
2. **`RAILS_MASTER_KEY`**:
   - Abra o arquivo `config/master.key` na sua máquina.
   - Copie todo o código contido nele e cole no campo de valor dessa variável.
   - *Isso é necessário para o Rails ler as credenciais encriptadas.*
3. **`RAILS_ENV`**:
   - Defina o valor como `production`.

Depois de preencher as variáveis, clique em **Create Web Service**.

O Render começará a baixar o código, instalar as dependências, pré-compilar os arquivos de front-end (HTML/CSS/JS) e rodar as migrações do banco.

---

## 5. (Opcional) Rodar o Seed para povoar o banco com usuários iniciais

Como o seu arquivo `db/seeds.rb` limpa e recria dados importantes (como o usuário administrador e motoristas), você pode querer rodar o seed uma vez após o deploy terminar com sucesso.

Para fazer isso:
1. No painel do seu Web Service no Render, clique na opção **Shell** no menu lateral esquerdo.
2. Digite o seguinte comando e aperte Enter:
   ```bash
   bundle exec rails db:seed
   ```
3. Aguarde o comando finalizar. Ele imprimirá as mensagens como:
   `Limpando banco de dados...`
   `Criando usuários...`
   
Pronto! Seu projeto estará rodando no Render com os usuários de teste cadastrados.
