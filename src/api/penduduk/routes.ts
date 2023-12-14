import { Router } from "express";
import PendudukHandler from "./handler";
import AuthHandler from "../authentication/handler";

class PendudukRouter {
    private router: Router;
    private handler: PendudukHandler;

    constructor(router: Router, handler: PendudukHandler) {
        this.router = router;
        this.handler = handler;
    }

    public use(): Router {
        this.router.post("/penduduk", AuthHandler.verifyAuth, this.handler.addPenduduk);
        this.router.get("/penduduk", this.handler.getAllPenduduk);
        this.router.get("/penduduk/custom", this.handler.customQuery);

        return this.router;
    }
}

export default PendudukRouter;