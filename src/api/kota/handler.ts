import { Request, Response } from "express";
import KotaSQL from "@services/sql/KotaSQL";
import ClientError from "../../excepts/ClientError";

class KotaHandler {
    private kotaService: KotaSQL;

    constructor(kotaService: KotaSQL) {
        this.kotaService = kotaService;

        // Bind
        this.addKota = this.addKota.bind(this);
        this.getAllKota = this.getAllKota.bind(this);
        this.customKota = this.customKota.bind(this);
    }

    public async addKota(req: Request, res: Response): Promise<void> {
        try {
            const body = req.body;
            const noKota = await this.kotaService.addKota(body);

            res.status(201).json({
                status: "SUCCESS",
                message: `Berhasil menambahkan kota dengan id: ${noKota}`
            })
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                })
            }
        }
    }

    public async getAllKota(req: Request, res: Response): Promise<void> {
        try {
            const result = await this.kotaService.getAllKota();

            res.status(200).json({
                status: "SUCCESS",
                data: result
            })
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                })
            }
        }
    }

    public async customKota(req: Request, res: Response): Promise<void> {
        try {
            const { query } = req.body;
            const result = await this.kotaService.customQueryKota(query);

            res.status(200).json({
                status: "SUCCESS",
                data: result
            });
        } catch (err) {
            if (err instanceof ClientError) {
                res.status(err.statusCode).json({
                    status: "FAILED",
                    message: err.message
                })
            }
        }
    }
}

export default KotaHandler;