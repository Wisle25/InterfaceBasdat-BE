import sql, { ConnectionPool} from "mssql";
import ClientError from "../../excepts/ClientError";

class UsersSQL {
    private pool: ConnectionPool;

    constructor(pool: ConnectionPool) {
        this.pool = pool;
    }

    public async registerUser(name: string, email: string, hashedPassword: string) {
        const result = await this.pool.request()
            .input("name", sql.VarChar(30), name)
            .input("email", sql.VarChar(30), email)
            .input("password", sql.VarChar(60), hashedPassword)
            .query(
                `INSERT INTO users(name, email, password) OUTPUT Inserted.id 
                 VALUES(@name, @email, @password)`
        );

        if (!result.rowsAffected) throw new ClientError("Tidak dapat melakukan registrasi!", 401);

        return result.recordset[0].id;
    }

    public async getUsers() {
        const result = await this.pool.request()
            .query("SELECT id, name FROM users");

        return result.recordset;
    }

    public async getUserId(id: string) {
        const result = await this.pool.request()
            .input("id", sql.UniqueIdentifier(), id)
            .query("SELECT id, name, email FROM users WHERE id = @id");

        return result.recordset;
    }

    public async getUserCredential(email: string) {
        const result = await this.pool.request()
            .input("email", sql.VarChar(30), email)
            .query("SELECT id, password FROM users WHERE email = @email");

        if (result.recordset.length == 0)
            throw new ClientError("Email tidak ditemukan!", 401);

            return result.recordset[0];
    }
}

export default UsersSQL;
