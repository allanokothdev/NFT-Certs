import '../styles/globals.css'
import Link from 'next/link'
import Head from 'next/head'

function MyApp({ Component, pageProps }) {

  return (
    <div>
      <nav className="border-b p-6 place-content-center">
        <p className="text-4xl font-bold mt-4  ">
          NFT Certs
        </p>
        <div className="flex mt-4">
          
          <Link href="/my-certificates">
            <a className="mr-6 text-pink-500">
              Certificates
            </a>
          </Link>
          
          <Link href="/create-certificate">
            <a className="mr-6 text-pink-500">
              Create Certificate
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default MyApp