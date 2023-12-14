import { Router } from "express";
import AuthHandler from "./handler";

class AuthRouter {
    private router: Router;
    private handler: AuthHandler;

    constructor(router: Router, handler: AuthHandler) {
        this.router = router;
        this.handler = handler;
    }

    public use(): Router {
        this.router.post("/auth", this.handler.login);
        this.router.delete("/auth", this.handler.logout);

        return this.router;
    }
}

export default AuthRouter;