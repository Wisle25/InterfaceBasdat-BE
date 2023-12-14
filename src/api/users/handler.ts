import bcrypt from "bcrypt";
import { Request, Response } from "express";
import UsersSQL from "@services/sql/UsersSQL";
import ClientError from "../../excepts/ClientError"

class UserHandler {
    private userService: UsersSQL;

    constructor(userService: UsersSQL) {
        this.userService = userService;

        this.registerUser = this.registerUser.bind(this);
        this.getUsers = this.getUsers.bind(this);
        this.getUserId = this.getUserId.bind(this);
    }
        
    public async registerUser(req: Request, res: Response): Promise<void> {
        try {
            const { name, email, password } = req.body;
            const hashedPassword = await bcrypt.hash(password, 10);
    
            const id = await this.userService.registerUser(name, email, hashedPassword);
    
            res.status(201).json({
                status: "SUCCESS",
                message: `Berhasil melakukan registrasi dengan ID: ${id}`,
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

    public async getUserId(req: Request, res: Response): Promise<void> {
        const { id } = req.params;

        const result = await this.userService.getUserId(id);

        res.status(200).json({
            status: "SUCCESS",
            code: 200,
            data: result[0]
        });
    }

    public async getUsers(req: Request, res: Response): Promise<void> {
        const result = await this.userService.getUsers();

        res.status(200).json({
            status: "SUCCESS",
            code: 200,
            data: result
        });
    }
}


export default UserHandler;