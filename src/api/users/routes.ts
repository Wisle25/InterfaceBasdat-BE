import express, { Router } from "express";
import UserHandler from "./handler";

class UserRouter {
    private router: Router;
    private handler: UserHandler;

    constructor(router: Router, handler: UserHandler) {
        this.router = router;
        this.handler = handler;
    }

    public use(): Router {
        this.router.post("/users", this.handler.registerUser);
        this.router.get("/users/:id", this.handler.getUserId);
        this.router.get("/users", this.handler.getUsers);

        return this.router;
    }
}

export default UserRouter;