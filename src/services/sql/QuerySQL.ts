import ClientError from "../../excepts/ClientError";
import sql, { ConnectionPool, IResult } from "mssql";

class QuerySQL {
    private poolInterface: ConnectionPool;
    private poolPendudukan: ConnectionPool;

    constructor(poolInterface: ConnectionPool, poolPendudukan: ConnectionPool) {
        this.poolInterface = poolInterface;
        this.poolPendudukan = poolPendudukan;
    }

    public async addQuery(name: string, query: string) {
        const result: IResult<any> = await this.poolInterface.request()
            .input("name", sql.VarChar(100), name)
            .input("queryContent", sql.Text(), query)
            .query(`INSERT INTO query (name, queryContent)
                    OUTPUT Inserted.id
                    VALUES(@name, @queryContent);
            `);

        if (!result.rowsAffected) throw new ClientError("Cannot add new query!", 401);

        return result.recordset[0].id;
    }

    public async getAllQueries() {
        const result: IResult<any> = await this.poolInterface.request()
            .query("SELECT * FROM query")

        return result.recordset;
    }

    public async executeQuery(id: string) {
        const result: IResult<any> = await this.poolInterface.request()
            .input("id", sql.UniqueIdentifier(), id)
            .query(
                "SELECT queryContent FROM query WHERE id = @id"
            );
        
        if (!result.recordset.length) throw new ClientError("Query tidak ditemukan!", 404);

        // Actual query
        const queryResult: IResult<any> = await this.poolPendudukan.request()
                .query(result.recordset[0].queryContent);

        return queryResult.recordset;
    }

    public async DMLQuery(query: string) {
        const result: IResult<any> = await this.poolPendudukan.request()
            .query(query);

        if (!result.rowsAffected) throw new ClientError("Tidak bisa melakukan query!", 400);

        return result.rowsAffected;
    }
}

export default QuerySQL;