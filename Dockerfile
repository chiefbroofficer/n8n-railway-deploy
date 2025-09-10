FROM n8nio/n8n:latest

ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

CMD ["n8n"]