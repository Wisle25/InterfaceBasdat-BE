import { Router } from "express";
import QueryHandler from "./handler";

class QueryRouter {
    private router: Router;
    private handler: QueryHandler;

    constructor(router: Router, handler: QueryHandler) {
        this.router = router;
        this.handler = handler;
    }

    public use(): Router {
        this.router.post("/query", this.handler.addQuery);
        this.router.get("/query", this.handler.getAllQueries);
        this.router.post("/query/:id", this.handler.executeQuery);
        this.router.put("/query", this.handler.DMLQuery);

        return this.router;
    }
}

export default QueryRouter;