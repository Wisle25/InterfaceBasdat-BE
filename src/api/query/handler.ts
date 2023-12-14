import ClientError from "../../excepts/ClientError";
import QuerySQL from "@services/sql/QuerySQL";
import { Request, Response } from "express";

class QueryHandler {
    private queryService: QuerySQL;

    constructor(queryService: QuerySQL) {
        this.queryService = queryService;

        this.addQuery = this.addQuery.bind(this);
        this.executeQuery = this.executeQuery.bind(this);
        this.getAllQueries = this.getAllQueries.bind(this);
        this.DMLQuery = this.DMLQuery.bind(this);
    }

    public async addQuery(req: Request, res: Response) {
        try {
            const { name, query } = req.body;
    
            const id = await this.queryService.addQuery(name, query);
         
            res.status(201).json({
                status: "SUCCESS",
                message: `Berhasil membuat query dengan Id: ${id}`
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

    public async getAllQueries(req: Request, res: Response) {
        try {
            const result = await this.queryService.getAllQueries();
         
            res.status(201).json({
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

    public async executeQuery(req: Request, res: Response) {
        try {
            const { id } = req.params;

            const result = await this.queryService.executeQuery(id);
         
            res.status(201).json({
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

    public async DMLQuery(req: Request, res: Response) {
        try {
            const { query } = req.body;
            const affected = await this.queryService.DMLQuery(query)

            res.status(200).json({
                status: "SUCCESS",
                message: `affected rows ${affected}`
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
}

export default QueryHandler;