class ClientError extends Error {
    public statusCode: number;

    constructor(message: string, code: number) {
        super(message);

        this.name = "ClientError";
        this.statusCode = code;
    }
}

export default ClientError;