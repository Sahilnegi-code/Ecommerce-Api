FROM node:18.18.0-alpine
WORKDIR /app

# Copy package files first for better caching
COPY Ecommerce/package*.json ./
COPY Ecommerce/tsconfig.json ./

RUN npm install

RUN npm list typescript
RUN npx tsc --version

# Copy prisma schema
COPY Ecommerce/prisma ./prisma/

COPY Ecommerce/src ./src/

COPY Ecommerce/nodemon.json ./nodemon.json


# Generate Prisma Client
RUN npx prisma generate


# Verify Prisma client is generated
RUN ls -la node_modules/.prisma/client/

# Build the application
RUN npm run build

EXPOSE 5000

CMD ["sh", "-c", "npx prisma generate && npx prisma db push --accept-data-loss --skip-generate && npm start"]
# CMD  ["npx prisma migrate deploy" , "&&" , "npm", "start" ]




