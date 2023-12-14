import sql, { ConnectionPool, IResult } from "mssql";
import IPenduduk from "@interfaces/IPenduduk";
import ClientError from "../../excepts/ClientError";

class PendudukSQL {
    private pool: ConnectionPool;

    constructor(pool: ConnectionPool) {
        this.pool = pool;
    }

    public async addPenduduk(penduduk: IPenduduk) {
        const result: IResult<IPenduduk> = await this.pool.request()
            .input("nama", sql.VarChar(60), penduduk.Nama)
            .input("jenis_kelamin", sql.VarChar(9), penduduk.JenisKelamin)
            .input("agama", sql.VarChar(9), penduduk.Agama)
            .input("no_telp", sql.VarChar(12), penduduk.NoTelp)
            .input("lama_tinggal", sql.TinyInt(), penduduk.LamaTinggal)
            .input("golongan_darah", sql.VarChar(3), penduduk.GolonganDarah)
            .input("kewarganegaraan", sql.VarChar(3), penduduk.Kewarganegaraan)
            .input("status", sql.VarChar(12), penduduk.Status)
            .input("no_kota_menetap", sql.UniqueIdentifier, penduduk.NoKotaMenetap)
            .query(`INSERT INTO penduduk (Nama, JenisKelamin, Agama, NoTelp, LamaTinggal, GolonganDarah, Kewarganegaraan, Status, NoKotaMenetap) 
                    OUTPUT Inserted.NIK
                    VALUES (@nama, @jenis_kelamin, @agama, @no_telp, @lama_tinggal, @golongan_darah, @kewarganegaraan, @status, @no_kota_menetap);
        `);
                    
        if (result.recordset.length == 0) throw new ClientError("Tidak dapat menambahkan penduduk!", 401);
                    
        return result.recordset[0].NIK;
    }

    public async getAllPenduduk(): Promise<sql.IRecordSet<IPenduduk>> {
        const result: IResult<IPenduduk> = await this.pool.request()
            .query("SELECT NIK, Nama, JenisKelamin, Agama, Kewarganegaraan FROM penduduk");

        return result.recordset;
    }

    public async customQuery(query: string): Promise<sql.IRecordSet<any>> {
        const result: IResult<any> = await this.pool.request()
            .query(query);

        return result.recordset;
    }
}

export default PendudukSQL;