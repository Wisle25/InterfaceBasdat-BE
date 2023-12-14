import express, { Express } from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import cors from "cors";
import cookieParser from "cookie-parser"

// API
import { UserRouter, UserHandler } from "./api/users"
import { AuthRouter, AuthHandler } from "./api/authentication"
import { QueryHandler, QueryRouter } from "./api/query";
import UsersSQL from "./services/sql/UsersSQL";
import { ConnectionPool } from "mssql";
import QuerySQL from "./services/sql/QuerySQL";

dotenv.config();

const app: Express = express();
const PORT = process.env.PORT;

// Using middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// Setup Database
const interfaceConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME_INTERFACE,
    server: "localhost",
    options: {
        trustServerCertificate: true
    }
}

const kependudukanConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME_KEPENDUDUKAN,
    server: "localhost",
    options: {
        trustServerCertificate: true
    }
}

const interfacePool    = new ConnectionPool(interfaceConfig);
const kependudukanPool = new ConnectionPool(kependudukanConfig);

interfacePool   .connect();
kependudukanPool.connect();

// Registering Services
const usersSQL = new UsersSQL(interfacePool);
const querySQL = new QuerySQL(interfacePool, kependudukanPool);

// Registering API
const userHandler = new UserHandler(usersSQL);
const user        = new UserRouter(express.Router(), userHandler);

const authHandler = new AuthHandler(usersSQL);
const auth        = new AuthRouter(express.Router(), authHandler);

const queryHandler = new QueryHandler(querySQL);
const query        = new QueryRouter(express.Router(), queryHandler);

// API
app.use(user.use());
app.use(auth.use());
app.use(query.use());

app.listen(PORT, () => {
    console.log(`Server is running at ${PORT}`);
});
