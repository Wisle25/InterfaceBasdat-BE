import sql, { ConnectionPool, IRecordSet, IResult, config } from "mssql";
import IKota from "@interfaces/IKota";

class KotaSQL {
    private pool: ConnectionPool;

    constructor(pool: ConnectionPool) {
        this.pool = pool;
    }

    public async addKota(kota: IKota) {
        const result: IResult<IKota> = await this.pool.request()
            .input("nama_kota", sql.VarChar(30), kota.NamaKota)
            .input("nama_provinsi", sql.VarChar(30), kota.NamaProvinsi)
            .query(`INSERT INTO kota (NamaKota, NamaProvinsi) 
                    OUTPUT Inserted.NoKota
                    VALUES (@nama_kota, @nama_provinsi);
        `);

        return result.recordset[0].NoKota;
    }

    public async getAllKota() {
        const result: IResult<IKota> = await this.pool.request()
            .query("SELECT * FROM kota");

        return result.recordset;
    }

    public async customQueryKota(query: string) {
        const result = await this.pool.request().query(query);

        return result.recordset;
    }
}

export default KotaSQL;