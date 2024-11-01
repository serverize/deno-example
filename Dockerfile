FROM denoland/deno:alpine AS base
WORKDIR /app

FROM base AS deps
WORKDIR /app
COPY deno.json .
RUN deno install --entrypoint deno.json

FROM deps AS builder
WORKDIR /app
COPY . .
RUN deno compile --allow-net --allow-env --output entry main.ts

FROM base AS start
COPY --from=builder /app/entry ./entry
USER deno
EXPOSE 8000
CMD ["./entry"]