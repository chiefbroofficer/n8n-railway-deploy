FROM n8nio/n8n:latest

ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

# Use the default entrypoint from n8n image
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["n8n", "start"]