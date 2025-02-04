console.log(

);


// https://www.boost.org/doc/libs/
console.log(
  $x('/html/body/div[2]/div/div[1]/div/div/div[2]/dl/dt[a]')
  .map(/** @param {HTMLElement} dt */ dt => {
      const title = dt.textContent.trim();
      const link = dt.querySelector('a')?.href || 'N/A';
      return `⚓ ${title} ; ${link}`;
  })
  .join("\n")
);