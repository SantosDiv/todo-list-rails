# Todo list - Rails
<p align="center">
  <a href="https://todolist-service-ukv6.onrender.com/" target="_blank">Teste o projeto</a>
</p>

![todolist](https://user-images.githubusercontent.com/68401286/236014550-052ab5c7-68af-4f9c-8723-18fb93b325b5.gif)


## Proposta do projeto
O projeto tem como proposta de ser uma lista de tarefas, onde cada tarefa pode ter sub-tarefas. Isso possibilita um destrinchamento maior de uma tarefa.

## Tecnologias utilizadas
Para a realização deste projeto, foi utilizado **Ruby on Rails, Bootstrap, Ruby, Rspec, CI Github, Github Projects, Figma.**
### Ruby on Rails (RoR)
Ele é um framework de base ruby que possibilita a criação de páginas HTML, CSS e Javascript, com renderização do lado do servidor. Ou seja, o server processa a página antes de chegar ao Cliente (Navegador pore exemplo). Isso ganha em Indexação, processamento, segurança e entre outras coisas. O seu conjunto de bibliotecas facilitam o desenvolvimento, fornecendo uma estrutura básica, mas que mesmo assim é completa.

O [Rails](https://rubyonrails.org/) utiliza um modelo de estrutura de projeto chamado de MVC (model-views-controller). Que é a forma que ele processa a comunicação entre banco de dados e cliente.

### Bootstrap
Ele é basicamente um conjunto de ferramentas front-end, que além de outras coisas, traz uma produtividade quando se trata de estilização do seu projeto. Ele traz estilos prontos, abstraindo os códigos css puro. Entretanto ele entrega, no passo final, a folha de estilo CSS.

### Ruby
Segundo a página oficial "é uma linguagem dinâmica, open source com foco na simplicidade e na produtividade. Tem uma sintaxe elegante de leitura natural e fácil escrita". ([Ruby org](https://www.ruby-lang.org/pt/))

### Figma
Utilizado para prototipar projetos, criando layouts, mockups, animações entre outras funcionalidades.
Para este projeto, foi criado um layout simples e mais clean. [Link do projeto figma](https://www.figma.com/file/VHy2X0hupETMt4WFA07oV5/Todo-list-rails?node-id=0%3A1&t=Jl2PgqyhQdYOBMKN-1)
![image](https://user-images.githubusercontent.com/68401286/236016011-6a5079a9-8b88-4ec3-a23f-2f8b7ee6c46f.png)


Neste projeto foi utilizado o ruby puro, com traços de **POO, utilizando boas responsabilidades de classes, garantindo invariâncias de classes, herança e padrão clean code**.

## Diferenciais propostos
Durante a criação do projeto, foi utilizado diversos recursos para que tudo fosse criado com o melhor equilíbrio de produtividade e eficiência.
Dentre diversas implementações, podem-se destacar:
 - **Github projects** - para a organização do projeto (Kanban);
 - **Figma** - utilizado para a criação da proposta do layout do projeto;
 - **Cobertura de testes** - utilizando Rspec;
 - **Pipeline CI Github** - pipelines que são rodados em cada push (no caso deste projeto), rodando os testes antes dos merges;
 - **Básico de POO** - Foi entendido que era preciso a abstração para a criação e atualização das tasks. Esta abstração se concretizou na criação de use_cases, presenters e herança;
 - **Definição de complexidade** - para cada card, foi marcado uma complexidade, baseado no impacto no sistema, entendimento do problema e tempo de execução.

## Como executar/Testar?
**Online**
[Projeto TodoList](https://todolist-service-ukv6.onrender.com/)

**Local**

```
1) Fork do projeto
2) $ git clone git@github.com:YOUR_USERNAME_GITHUB/todo-list-rails.git
3) $ bundle install && yarn install

4) Copiar o arquivo `local_env.example.yml` e renomear para `local_env.yml`
5) Editar as chaves do postgres dentro do arquivo `local_env.yml`

6) $ bundle exec rails db:create
7) $ bundle exec rails db:migrate

$ rails s

```
