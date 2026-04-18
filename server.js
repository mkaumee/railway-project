const express = require('express');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 3000;

// Serve install scripts with correct content-type
app.get('/install.sh', (req, res) => {
  res.type('text/plain');
  res.sendFile(path.join(__dirname, 'install.sh'));
});

app.get('/install.ps1', (req, res) => {
  res.type('text/plain');
  res.sendFile(path.join(__dirname, 'install.ps1'));
});

// Health check / info endpoint
app.get('/', (req, res) => {
  res.json({
    name: 'Gmail CLI Installer',
    status: 'ok',
    endpoints: {
      'macOS/Linux': `${req.protocol}://${req.get('host')}/install.sh`,
      'Windows': `${req.protocol}://${req.get('host')}/install.ps1`
    },
    usage: {
      'macOS/Linux': `curl -fsSL ${req.protocol}://${req.get('host')}/install.sh | bash`,
      'Windows': `iwr ${req.protocol}://${req.get('host')}/install.ps1 | iex`
    }
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Install scripts available at:`);
  console.log(`  - /install.sh`);
  console.log(`  - /install.ps1`);
});
