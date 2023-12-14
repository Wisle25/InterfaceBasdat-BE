import bcrypt from "bcrypt"
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import UsersSQL from "@services/sql/UsersSQL";
import ClientError from "../../excepts/ClientError";

class AuthHandler {
    private userService: UsersSQL;

    constructor(userService: UsersSQL) {
        this.userService = userService;

        // Bind
        this.login = this.login.bind(this);
        this.logout = this.logout.bind(this);
    }

    public async login(req: Request, res: Response): Promise<void> {
        try {

            const { email, password } = req.body;
    
            const { id, password: hashedPassword } = await this.userService.getUserCredential(email);
    
            // Check password
            const match = await bcrypt.compare(password, hashedPassword);
    
            if (!match) throw new ClientError("Password salah!", 401);
    
            // Generate JWT
            const accessToken = jwt.sign({ id: id}, process.env.TOKEN_SECRET as string, { expiresIn: "1200s" })
    
            res.cookie("AccessToken", accessToken, { httpOnly: true });
            res.status(201).json({
                status: "SUCCESS",
                message: "Berhasil login!"
            });
        } catch (err) {
            if (err instanceof ClientError)
            {
                res.clearCookie("AccessToken");
                res.json({
                    status: "SUCCESS",
                    message: "Berhasil login!"
                });
            }
        }
    }

    public static verifyAuth(req: Request, res: Response, next: NextFunction): void {
        try {
            const { AccessToken } = req.cookies;

            // Verifying AccessToken if available
            if (!AccessToken) throw new ClientError("Authentication needed!", 403);
            
            const user = jwt.verify(AccessToken as string, process.env.TOKEN_SECRET as string);
            (req as any).user = user;
    
            next();
        } catch (err) {
            if (err instanceof ClientError)
            {
                res.clearCookie("AccessToken");
                res.status(err.statusCode).json({
                    status: "Failed",
                    message: "Anda harus login untuk melanjutkan!"
                });
            }
        }
    }

    public logout(req: Request, res: Response): void {
        res.clearCookie("AccessToken");
        res.status(200).json({
            status: "SUCCESS",
            message: "Berhasil logout!"
        });
    }
}

export default AuthHandler;