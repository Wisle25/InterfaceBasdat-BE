import { Router } from "express";
import KotaHandler from "./handler";
import AuthHandler from "../authentication/handler";

class KotaRouter {
    private handler: KotaHandler;
    private router: Router;

    constructor(router: Router, handler: KotaHandler) {
        this.router = router;
        this.handler = handler;
    }

    public use(): Router {
        this.router.post("/kota", AuthHandler.verifyAuth, this.handler.addKota);
        this.router.get("/kota", this.handler.getAllKota);
        this.router.get("/kota/custom", AuthHandler.verifyAuth, this.handler.customKota);

        return this.router;
    }
}

export default KotaRouter;