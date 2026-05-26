# Expert AI Agents & Skills Collection

Uma coleção abrangente de **37 agentes especializados** para GitHub Copilot, organizados em 9 categorias: frontend, backend, dados, automação, documentação, revisão, IA, mobile e arquitetura.

## Visão Geral

Esta coleção fornece agentes customizados para o GitHub Copilot Chat no VS Code, seguindo as melhores práticas da indústria:

- **Temperatura = 0**: Respostas determinísticas e precisas
- **Orientação a tarefas**: Executam apenas o que foi solicitado
- **Melhores práticas**: Seguem padrões consolidados do mercado
- **Código production-ready**: Pronto para ambientes de produção
- **Segurança**: Validação de inputs, OWASP guidelines, princípio de menor privilégio

## Instalação Rápida

### Opção 1: Script Automático (Recomendado)

O script interativo permite selecionar quais agentes instalar:

```bash
# Dê permissão de execução (se necessário)
chmod +x setup-agents.sh

# Instalação interativa (com menu de seleção)
./setup-agents.sh
```

O menu oferece duas opções de destino:

| Opção | Destino | Escopo |
|-------|---------|--------|
| Projeto | `.github/agents/` | Visível apenas no workspace atual |
| Global | `~/.claude/agents/` | Visível em todos os projetos |

Formatos de seleção aceitos:

```bash
1-37       # Todos os agentes
2-5        # Agentes 2, 3, 4 e 5
1,3,7-10   # Agentes 1, 3, 7, 8, 9 e 10
```

### Opção 2: Instalação Manual

1. Clone ou baixe este repositório
2. Copie os arquivos `.md` dos agentes desejados para:
   - **Projeto**: `.github/agents/`
   - **Global**: `~/.claude/agents/`
3. Recarregue o VS Code (`Ctrl+Shift+P` > `Developer: Reload Window`)

### Verificação da Instalaçãoc

Após a instalação:

1. Abra o VS Code
2. Abra o Copilot Chat (`Ctrl+Shift+I`)
3. Clique no dropdown de agentes - os agentes instalados aparecerão na lista
4. Selecione o agente desejado e converse com o especialista

## Estrutura do Projeto

```
agents-skills/
├── a_frontend/          # 4 agentes - React, Next.js, Vue, UI/UX
├── b_backend/           # 6 agentes - Node.js, Python, Java, Go, Database
├── c_data/              # 3 agentes - Análise, ML, Engenharia de Dados
├── d_automation/        # 7 agentes - DevOps, CI/CD, Testing, IaC, Docker, GitHub
├── e_documentation/     # 3 agentes - Technical Writer, API Docs, Architecture Docs
├── f_reviewer/          # 3 agentes - Code Review, Doc Review, Orchestrator
├── g_ai/               # 4 agentes - LangChain, Prompt Engineering, RAG, Web Research
├── h_mobile/           # 3 agentes - Flutter, React Native, Swift/iOS
├── i_architecture/     # 4 agentes - DDD, Event Sourcing, Solution Architect, Tech Lead
├── setup-agents.sh     # Script de instalação interativo
└── README.md
```

---

## Frontend Agents (a_frontend/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| React + TypeScript Expert | `react-typescript-expert.md` | React 18+, TypeScript strict, hooks, Server Components, React Query |
| Next.js Expert | `nextjs-expert.md` | Next.js 14+ App Router, Server Components, Server Actions, SEO |
| Vue.js Expert | `vue-expert.md` | Vue 3 Composition API, Pinia, Vue Router, TypeScript |
| UI/UX & Styling Expert | `ui-ux-expert.md` | Tailwind CSS, CSS-in-JS, Responsive Design, WCAG 2.1 AA/AAA |

## Backend Agents (b_backend/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| Node.js API Expert | `nodejs-api-expert.md` | Express, Fastify, NestJS, REST/GraphQL, Prisma |
| Python FastAPI Expert | `python-fastapi-expert.md` | FastAPI, Pydantic, SQLAlchemy 2.0 async, OAuth2 |
| Java Spring Boot Expert | `java-spring-expert.md` | Spring Boot 3.x, Spring Security, JPA, JUnit 5 |
| Golang Expert | `golang-expert.md` | Go 1.21+, Gin/Fiber/Echo, goroutines, channels |
| Database Expert | `database-expert.md` | PostgreSQL, MySQL, query optimization, indexing, NoSQL |
| Database Ops | `database-ops.md` | Execução SQL via MCP, schema management, otimização |

## Data Agents (c_data/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| Data Analyst | `data-analyst.md` | Pandas, NumPy, Polars, visualização, estatística |
| ML Engineer | `ml-engineer.md` | scikit-learn, PyTorch, TensorFlow, MLOps, feature engineering |
| Data Engineer | `data-engineer.md` | Airflow, PySpark, Kafka, ETL/ELT, data quality |

## Automation Agents (d_automation/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| DevOps Expert | `devops-expert.md` | Docker, Kubernetes, monitoring, security scanning |
| CI/CD Expert | `cicd-expert.md` | GitHub Actions, GitLab CI, Jenkins, deployment strategies |
| Testing Expert | `testing-expert.md` | Jest, Vitest, pytest, Cypress, Playwright, TDD |
| Infrastructure as Code | `infrastructure-as-code.md` | Terraform, Pulumi, CloudFormation, Bicep, Ansible |
| Docker Ops | `docker-ops.md` | Container operations via MCP, image building, orchestration |
| Filesystem Agent | `filesystem-agent.md` | File operations via MCP, scaffolding, refactoring |
| GitHub Ops | `github-ops.md` | GitHub operations via MCP: issues, PRs, repos, workflows |

## Documentation Agents (e_documentation/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| Technical Writer | `technical-writer.md` | READMEs, user guides, tutorials, documentation structure |
| API Documentation | `api-documentation.md` | OpenAPI 3.0, GraphQL schemas, API references |
| Architecture Documentation | `architecture-documentation.md` | ADRs, C4 model, PlantUML, Mermaid diagrams |

## Reviewer Agents (f_reviewer/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| Code Reviewer | `code-reviewer.md` | Review com double-check system para qualidade e segurança |
| Documentation Reviewer | `documentation-reviewer.md` | Review de documentação: precisão, completude, coerência |
| Review Orchestrator | `review-orchestrator.md` | Orquestra multi-pass review entre revisores especializados |

## AI Agents (g_ai/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| LangChain Expert | `langchain-expert.md` | LangChain, LlamaIndex, RAG systems, chains, AI agents |
| Prompt Engineer | `prompt-engineer.md` | Prompt optimization, chain-of-thought, structured outputs |
| RAG Specialist | `rag-specialist.md` | Retrieval optimization, embeddings, knowledge bases |
| Web Research Agent | `web-research-agent.md` | Web research via MCP (fetch, brave-search) |

## Mobile Agents (h_mobile/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| Flutter Expert | `flutter-expert.md` | Flutter/Dart, cross-platform mobile, web e desktop |
| React Native Expert | `react-native-expert.md` | React Native, cross-platform mobile, native performance |
| Swift iOS Expert | `swift-ios-expert.md` | Swift, SwiftUI, iOS e macOS nativo |

## Architecture Agents (i_architecture/)

| Agente | Arquivo | Especialização |
|--------|---------|---------------|
| DDD Expert | `ddd-expert.md` | Bounded contexts, aggregates, strategic/tactical patterns |
| Event Sourcing Expert | `event-sourcing-expert.md` | Event stores, CQRS, projections, temporal queries |
| Solution Architect | `solution-architect.md` | System design, scalability patterns, technology selection |
| Tech Lead | `tech-lead.md` | Orquestrador que delega para agentes especializados |

---

## Como Usar

### Via Dropdown no Copilot Chat

1. Abra o Copilot Chat (`Ctrl+Shift+I`)
2. Clique no dropdown de agentes (acima do campo de input)
3. Selecione o agente especializado
4. Converse normalmente - o agente aplicará seu conhecimento especializado

### Invocação por Contexto

Mencione o tipo de expertise na sua pergunta:

```
"Crie um componente React com validação de formulário"
"Otimize este Dockerfile para produção"
"Crie testes E2E para este fluxo de autenticação"
"Revise este código focando em segurança e performance"
```

## Convenções

### Nomenclatura de Arquivos

- Agentes: `{especialidade}-expert.md` ou `{especialidade}-ops.md`
- kebab-case para nomes de arquivo
- Sufixo `-ops` para agentes com integração MCP

### Estrutura de Agentes

Cada agente segue esta estrutura no frontmatter YAML:

```yaml
---
name: Nome do Agente
description: Descrição breve
tools:           # (opcional) ferramentas MCP permitidas
  - name: tool-name
---
```

Corpo do arquivo:

1. **Contexto e Expertise**: Áreas de conhecimento
2. **Core Principles**: Princípios fundamentais
3. **Best Practices**: Melhores práticas com exemplos de código
4. **Constraints**: O que NUNCA e SEMPRE fazer
5. **Checklist**: Verificações antes de entregar
6. **Response Style**: Como o agente se comunica

## Princípios Gerais

### Todos os Agentes Devem:

- Temperatura = 0 (sem alucinações)
- Executar apenas o solicitado
- Seguir melhores práticas do mercado
- Fornecer código production-ready
- Incluir tratamento de erros
- Considerar segurança e performance
- Documentar código complexo

### Todos os Agentes NÃO Devem:

- Fazer suposições não verificadas
- Ignorar validações de entrada
- Expor dados sensíveis
- Usar práticas obsoletas
- Comprometer segurança por conveniência
- Adicionar funcionalidades não solicitadas

## Personalização

### Editando Agentes

Edite qualquer arquivo `.md` para ajustar o comportamento:

1. Modifique `name` e `description` no frontmatter
2. Ajuste a expertise, princípios e práticas
3. Reinstale com `./setup-agents.sh`

### Criando Novos Agentes

1. Crie um arquivo `.md` na pasta de categoria apropriada
2. Use a estrutura:

```markdown
---
name: Meu Agente
description: Descrição clara do que o agente faz
---

# Meu Agente

Contexto e expertise do agente.

## Core Principles

1. Princípio 1
2. Princípio 2

## Best Practices

[Exemplos de código e práticas]

## Constraints

- NEVER faça X
- ALWAYS faça Y
- ONLY implemente o que foi pedido
```

3. Execute `./setup-agents.sh` para instalar

## Troubleshooting

### Agentes não aparecem no dropdown

1. Verifique se o GitHub Copilot está instalado e ativo
2. Confirme que os arquivos foram copiados para `.github/agents/` ou `~/.claude/agents/`
3. Recarregue o VS Code (`Ctrl+Shift+P` > `Developer: Reload Window`)

### Script não executa

```bash
chmod +x setup-agents.sh
bash setup-agents.sh
```

### Conflito entre agentes

Se múltiplos agentes se aplicam ao mesmo contexto, selecione o agente desejado explicitamente no dropdown do Copilot Chat.

## Estrutura de Diretórios Após Instalação

### Instalação no Projeto

```
seu-projeto/
├── .github/
│   └── agents/
│       ├── react-typescript-expert.md
│       ├── nodejs-api-expert.md
│       ├── devops-expert.md
│       └── ...
└── ...
```

### Instalação Global

```
~/.claude/
└── agents/
    ├── react-typescript-expert.md
    ├── nodejs-api-expert.md
    ├── devops-expert.md
    └── ...
```

## Contribuindo

1. Fork este repositório
2. Crie uma branch para sua feature (`git checkout -b feature/novo-agente`)
3. Commit suas mudanças (`git commit -m 'Adiciona novo agente X'`)
4. Push para a branch (`git push origin feature/novo-agente`)
5. Abra um Pull Request

## Licença

Este projeto é open source e está disponível sob a [MIT License](LICENSE).

---
