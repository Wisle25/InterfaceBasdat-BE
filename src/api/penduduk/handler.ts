import { Request, Response } from "express";
import ClientError from "../../excepts/ClientError";
import IPenduduk from "@interfaces/IPenduduk";
import PendudukSQL from "@services/sql/PendudukSQL";

class PendudukHandler {
    private pendudukService: PendudukSQL;

    constructor(pendudukService: PendudukSQL) {
        this.pendudukService = pendudukService;

        // Bind
        this.addPenduduk = this.addPenduduk.bind(this);
        this.getAllPenduduk = this.getAllPenduduk.bind(this);
        this.customQuery = this.customQuery.bind(this);
    }

    public async addPenduduk(req: Request, res: Response): Promise<void> {
        try {
            const pendudukBody: IPenduduk = req.body;
            
            const NIK = await this.pendudukService.addPenduduk(pendudukBody);
            
            res.status(201).json({
                status: "SUCCESS",
                message: `Berhasil menambahkan penduduk dengan NIK: ${NIK}`
            });
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                });
            }
        }
    }

    public async getAllPenduduk(req: Request, res: Response): Promise<void> {
        try {
            const result = await this.pendudukService.getAllPenduduk();

            res.status(200).json({
                status: "SUCCESS",
                data: result
            });
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                });
            }
        }
    }

    public async customQuery(req: Request, res: Response): Promise<void> {
        try {
            const { query } = req.body;

            const result = await this.pendudukService.customQuery(query);

            res.status(200).json({
                status: "SUCCESS",
                data: result
            });
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                });
            }
        }
    }
}

export default PendudukHandler;
