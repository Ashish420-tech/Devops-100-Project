const express = require("express");
const app = express();

const ENV = process.env.NODE_ENV || "dev";

app.get("/", (req, res) => {
  res.send(`🚀 Running in ${ENV} environment`);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`App running on port ${PORT}`));
